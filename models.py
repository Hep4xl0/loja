from app import db


class Loja(db.Model):
    __tablename__ = 'lojas'
    
    id = db.Column(db.Integer, primary_key=True)
    nome = db.Column(db.String(100), nullable=False)
    estoque = db.Column(db.Integer, nullable=False)
    funcionarios = db.Column(db.Integer, nullable=False)
    gastos = db.Column(db.Float, nullable=False)

    def __repr__(self):
        return f'<Loja {self.nome}>'

class Funcionarios(db.Model):
    __tablename__ = 'funcionarios'

    id = db.Column(db.Integer, primary_key=True)
    nome = db.Column(db.String(100), nullable=False)
    cpf = db.Column(db.String(11), unique=True, nullable=False)
    nascimento = db.Column(db.Date, nullable=False)
    cargo = db.Column(db.String(100), nullable=False)
    salario = db.Column(db.Float, nullable=False)
    data_contratacao = db.Column(db.Date, nullable=False)
    
    loja_trabalho_id = db.Column(db.Integer, db.ForeignKey('lojas.id'), nullable=False)
    loja_trabalho = db.Column(db.String, db.ForeignKey('lojas.nome'), nullable=False)



class Produtos(db.Model):
    __tablename__ = 'produtos'

    id = db.Column(db.Integer, primary_key=True)
    nome = db.Column(db.String(100), nullable=False)
    categoria = db.Column(db.String(100), nullable=False)
    preco = db.Column(db.Float, nullable=False)
    estoque = db.Column(db.Integer, nullable=False)
    produtos_custo = db.Column(db.Float, nullable=False)
    vendas = db.Column(db.Integer, nullable=False)
    
    loja_id = db.Column(db.Integer, db.ForeignKey('lojas.id'), nullable=False)
    loja = db.Column(db.String, db.ForeignKey('lojas.nome'), nullable=False)
