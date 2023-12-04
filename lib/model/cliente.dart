class Cliente {
  int? id;
  String cpf;
  String nome;
  String sobrenome;

  Cliente(this.id, this.cpf, this.nome, this.sobrenome);
  Cliente.novo(this.cpf, this.nome, this.sobrenome);
}