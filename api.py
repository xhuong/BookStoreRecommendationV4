# import pickle
# import numpy as np
# from flask import Flask, request, jsonify
# from scipy.sparse import csr_matrix

# app = Flask(__name__)

# # Load necessary data and models
# model = pickle.load(open('artifacts/model.pkl', 'rb'))
# book_names = pickle.load(open('artifacts/book_names.pkl', 'rb'))
# final_rating = pickle.load(open('artifacts/final_rating.pkl', 'rb'))
# book_pivot = pickle.load(open('artifacts/book_pivot.pkl', 'rb'))


# def fetch_poster(suggestion):
#     book_name = []
#     ids_index = []
#     poster_url = []

#     for book_id in suggestion:
#         book_name.append(book_pivot.index[book_id])

#     for name in book_name[0]:
#         ids = np.where(final_rating['title'] == name)[0][0]
#         ids_index.append(ids)

#     for idx in ids_index:
#         url = final_rating.iloc[idx]['image_url']
#         poster_url.append(url)

#     return poster_url


# def recommend_book(book_name):
#     books_list = []
#     book_id = np.where(book_pivot.index == book_name)[0][0]
#     distance, suggestion = model.kneighbors(
#         book_pivot.iloc[book_id, :].values.reshape(1, -1), n_neighbors=6)

#     poster_url = fetch_poster(suggestion)

#     for i in range(len(suggestion)):
#         books = book_pivot.index[suggestion[i]]
#         for j in books:
#             books_list.append(j)
#     return books_list, poster_url


# @app.route('/recommend', methods=['GET'])
# def recommend():
#     book_name = request.args.get('book_name')
#     if book_name:
#         books_list, poster_url = recommend_book(book_name)
#         response = {
#             'recommended_books': books_list,
#             'poster_urls': poster_url
#         }
#         return jsonify(response)
#     else:
#         return jsonify({'error': 'Please provide a valid book name.'})


# if __name__ == '__main__':
#     app.run(debug=True)



#############################
# RETURN BOOK WITH ISBN

import pickle
import numpy as np
from flask import Flask, request, jsonify
from scipy.sparse import csr_matrix

app = Flask(__name__)

# Load necessary data and models
model = pickle.load(open('artifacts/model.pkl', 'rb'))
book_names = pickle.load(open('artifacts/book_names.pkl', 'rb'))
final_rating = pickle.load(open('artifacts/final_rating.pkl', 'rb'))
book_pivot = pickle.load(open('artifacts/book_pivot.pkl', 'rb'))


def fetch_poster(suggestion):
    book_name = []
    ids_index = []
    poster_url = []

    for book_id in suggestion:
        book_name.append(book_pivot.index[book_id])

    for name in book_name[0]:
        ids = np.where(final_rating['title'] == name)[0][0]
        ids_index.append(ids)

    for idx in ids_index:
        url = final_rating.iloc[idx]['image_url']
        poster_url.append(url)

    return poster_url


def recommend_book(book_name):
    books_list = []
    isbn_list = []
    book_id = np.where(book_pivot.index == book_name)[0][0]
    distance, suggestion = model.kneighbors(
        book_pivot.iloc[book_id, :].values.reshape(1, -1), n_neighbors=6)

    poster_url = fetch_poster(suggestion)

    for i in range(len(suggestion)):
        books = book_pivot.index[suggestion[i]]
        for j in books:
            books_list.append(j)
            isbn = final_rating.loc[final_rating['title'] == j, 'ISBN'].values[0]
            isbn_list.append(isbn) if 'ISBN' in final_rating.columns else isbn_list.append(None)
    return books_list, isbn_list, poster_url


@app.route('/recommend', methods=['GET'])
def recommend():
    book_name = request.args.get('book_name')
    if book_name:
        books_list, isbn_list, poster_url = recommend_book(book_name)
        # response = {
        #     'recommended_books': books_list,
        #     'isbn': isbn_list,
        #     'poster_urls': poster_url
        # }
        result = []
        for book, isbn, imageUrl in zip(books_list, isbn_list, poster_url):
            result.append({"book_name": book, "isbn":isbn, "imgSrc": imageUrl})
        return jsonify(result)
    else:
        return jsonify({'error': 'Please provide a valid book name.'})


if __name__ == '__main__':
    app.run(debug=True)

