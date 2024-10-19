from flask import render_template, jsonify
from models import Funcionarios, Loja, Produtos
from app import app, db


@app.route('/', methods=['GET'])
def adquirir_lojas():
    lojas = Loja.query.all()
    resultado = []
    for loja in lojas:
        dados = {
            'id': loja.id,
            'nome': loja.nome,
            'estoque': loja.estoque,
            'funcionarios': loja.funcionarios,
            'gastos': loja.gastos
        }
        resultado.append(dados)
    return jsonify(resultado)
