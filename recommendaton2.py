import itertools
import argparse
import pandas as pd
import numpy as np
from scipy.sparse import csr_matrix as sparse_csr_matrix
from implicit.als import AlternatingLeastSquares
 
 
def recommendations(order_id):
    transactions = pd.read_csv(
        "1.csv",
        usecols=["item_num", "customer_num", "qty_shipped", "order_num"],
        encoding="latin-1",
    )
 
    transactions["customer_num_id"] = (
        transactions["customer_num"].astype("category").cat.codes
    )
    transactions["order_num_id"] = transactions["order_num"].astype(
        "category").cat.codes
    transactions["item_num_id"] = transactions["item_num"].astype(
        "category").cat.codes
    # item_num_id = transactions.item_num_id.loc[transactions.order_num == 3790932]
 
    # transactions.to_csv('d.csv')
    # print(item_num_id)
    sparse_item_item = sparse_csr_matrix(
        (
            transactions["qty_shipped"],
            (transactions["item_num_id"], transactions["customer_num_id"]),
        )
    )
    # print(transactions.dtypes)
    model_items = AlternatingLeastSquares(
        factors=70, regularization=0.15, iterations=10)
    alpha_val = 35
 
    data_conf_items = (sparse_item_item * alpha_val).astype("double")
    model_items.fit(data_conf_items)
    order_numbers = order_id
    item_num_id = []
    item_number = []
    for orders in order_numbers:
        item_num_id.append(
            transactions.item_num_id.loc[transactions.order_num ==
                                         orders].iloc[0]
        )
        item_number.append(
            transactions.item_num.loc[transactions.order_num == orders])
    n_similar = 5
    results = []
    for item_number_id in item_num_id:
        similar = model_items.similar_items(item_number_id, n_similar)
 
        results.append(
            list(
                set(
                    transactions.item_num.loc[transactions.item_num_id == idx].iloc[0]
                    for idx, _ in similar
                )
            )
        )
 
    inputs = list(itertools.chain.from_iterable(item_number))
    recomm = list(itertools.chain.from_iterable(results))
    output = [inputs, recomm]
    data = pd.DataFrame(output, ["order_items", "recommendation"]).T
    data.to_csv("rec1.csv", index=False)
 
 
if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    required_args = parser.add_argument_group()
    required_args.add_argument(
        "-i", "--order_id", dest="order_id", required=True, nargs="*", type=int, default=[])
    arguments = parser.parse_args()
    recommendations(arguments.order_id)
