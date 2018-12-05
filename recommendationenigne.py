import pandas as pd
import numpy as np
from scipy.sparse import csr_matrix as sparse_csr_matrix
from implicit.als import AlternatingLeastSquares
 
transactions = pd.read_csv(
    "transactions.csv",
    usecols=["item_num", "customer_num", "qty_shipped"],
    encoding="latin-1",
)
print(transactions.head())
 
transactions["customer_num_id"] = (
    transactions["customer_num"].astype("category").cat.codes
)
transactions["item_num_id"] = transactions["item_num"].astype(
    "category").cat.codes
sparse_customer_products = sparse_csr_matrix(
    (
        transactions["qty_shipped"],
        (transactions["customer_num_id"], transactions["item_num_id"]),
    )
)
sparse_item_item = sparse_csr_matrix(
    (
        transactions["qty_shipped"],
        (transactions["item_num_id"], transactions["customer_num_id"]),
    )
)
model_items = AlternatingLeastSquares(
    factors=70, regularization=0.15, iterations=10)
model = AlternatingLeastSquares(factors=70, regularization=0.15, iterations=10)
alpha_val = 35
data_conf = (sparse_customer_products * alpha_val).astype("double")
data_conf_items = (sparse_item_item * alpha_val).astype("double")
# model_items.fit(data_conf_items)
model.fit(data_conf)
 
 
def user_item(customer):
    customer_num_id = transactions.customer_num_id.loc[
        transactions.customer_num == customer
    ].iloc[0]
 
    n_similar = 10
 
    similar = model.similar_items(customer_num_id, n_similar)
 
    results = list(
        set(
            transactions.item_num.loc[transactions.customer_num_id == idx].iloc[0]
            for idx, _ in similar
        )
    )
    return results
 
 
# def item_item(item_number1: str, item_number2: str):
#     import pdb
 
#     pdb.set_trace()
#     item_num_id = (
#         transactions.item_num_id.loc[transactions.item_num == str(
#             item_number1)].iloc[0]
#         | transactions.item_num_id.loc[transactions.item_num == str(item_number2)].iloc[
#             0
#         ]
#     )
 
#     n_similar = 10
 
#     similar = model_items.similar_items(item_num_id, n_similar)
 
#     results_items = list(
#         set(
#             transactions.item_num.loc[transactions.item_num_id == idx].iloc[0]
#             for idx, _ in similar
#         )
#     )
#     return results_items
 
 
recommendations = user_item(75399)
print(recommendations)
# recommendations_items = item_item(100216, 4639)
# print(recommendations_items)
