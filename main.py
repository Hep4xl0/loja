from flask import render_template, jsonify, request
from models import Funcionarios, Loja, Produtos
from app import app, db


@app.route('/lojas', methods=['GET'])
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

@app.route('/produtos', methods=['GET'])
def listar_produtos():
    produtos = Produtos.query.all()
    produtos_resultado = []
    
    for produto in produtos:
        dados_produto = {
            'id': produto.id,
            'nome': produto.nome,
            'categoria': produto.categoria,
            'preco': produto.preco,
            'estoque': produto.estoque,
            'produtos_custo': produto.produtos_custo,
            'vendas': produto.vendas,
            'loja_id': produto.loja_id
        }
        produtos_resultado.append(dados_produto)

    return jsonify(produtos_resultado)

@app.route('/funcionarios', methods=['GET'])
def listar_funcionarios():
    funcionarios = Funcionarios.query.all()
    funcionarios_resultado = []
    
    for funcionario in funcionarios:
        dados_funcionario = {
            'id': funcionario.id,
            'nome': funcionario.nome,
            'cpf': funcionario.cpf,
            'nascimento': funcionario.nascimento.isoformat(),
            'cargo': funcionario.cargo,
            'salario': funcionario.salario,
            'data_contratacao': funcionario.data_contratacao.isoformat(),
            'loja_trabalho_id': funcionario.loja_trabalho_id
        }
        funcionarios_resultado.append(dados_funcionario)

    return jsonify(funcionarios_resultado)

@app.route('/lojas', methods=['POST'])
def adicionar_loja():
    dados = request.json
    nova_loja = Loja(
        nome=dados['nome'],
        estoque=dados['estoque'],
        funcionarios=dados['funcionarios'],
        gastos=dados['gastos']
    )
    
    db.session.add(nova_loja)
    db.session.commit()
    
    return jsonify({'message': 'Loja adicionada', 'id': nova_loja.id}), 201


@app.route('/funcionarios', methods=['POST'])
def adicionar_funcionario():
    dados = request.json
    novo_funcionario = Funcionarios(
        nome=dados['nome'],
        cpf=dados['cpf'],
        nascimento=dados['nascimento'],
        cargo=dados['cargo'],
        salario=dados['salario'],
        data_contratacao=dados['data_contratacao'],
        loja_trabalho_id=dados['loja_trabalho_id'],
        loja_trabalho=dados['loja_trabalho']  # Não se esqueça de adicionar esta linha
    )
    
    db.session.add(novo_funcionario)
    db.session.commit()
    
    return jsonify({'message': 'Funcionário adicionado', 'id': novo_funcionario.id}), 201



@app.route('/produtos', methods=['POST'])
def adicionar_produto():
    dados = request.json
    novo_produto = Produtos(
        nome=dados['nome'],
        categoria=dados['categoria'],
        preco=dados['preco'],
        estoque=dados['estoque'],
        produtos_custo=dados['produtos_custo'],
        vendas=dados['vendas'],
        loja_id=dados['loja_id'],
        loja=dados['loja']  # Não se esqueça de adicionar esta linha
    )
    
    db.session.add(novo_produto)
    db.session.commit()
    
    return jsonify({'message': 'Produto adicionado', 'id': novo_produto.id}), 201

