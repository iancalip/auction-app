## LeilON

# Descrição
LeilON é uma plataforma de leilão online que promove a venda de produtos por valores mais acessíveis. Através de lances em lotes online, a plataforma gera uma grande circulação de produtos e usuários, tornando a aplicação dinâmica e intuitiva.

# Instalação
A aplicação está hospedada no GitHub, você pode cloná-la usando o seguinte comando:

`git clone https://github.com/iancalip/auction-app.git`

Depois acesse a pasta pelo terminal e rode o comando:

`bin/setup`

# Seeds

Para executar os seeds, você pode usar o seguinte comando:

`rails db:seed`

# Server

Caso queira acessar o site localmente, basta rodar o comando:

`rails s`

E acessar: "http://localhost:3000/"

# Pré-requisitos

  - Ruby 3.2.2
  - Rails 7.0.4.3
  - SQLite 3

# Dependências

A aplicação depende de várias gems, incluindo:

  - Devise
  - Bootstrap
  - Byebug
  - RSpec-Rails
  - Capybara

Você pode instalar todas as dependências executando:

bundle install

# Uso

A utilização da LeilON é intuitiva e simplista. Aqui estão algumas das principais funcionalidades:

  - Homepage: Exibe todos os lotes disponíveis e os que estão para começar, incluindo seus códigos de identificação e as datas de exibição.
  - Produtos: Mostra todos os produtos cadastrados na aplicação pelos administradores. Os usuários podem ver detalhes de cada produto e fazer lances se estiverem autenticados.
  - Meus Lotes: Mostra o histórico do usuário, incluindo os lotes que venceu, perdeu ou está participando.
  - Pesquisa: Permite aos usuários pesquisar lotes com produtos específicos ou acessar lotes específicos utilizando seus códigos de identificação.

Para administradores, a LeilON oferece funcionalidades adicionais, incluindo:

  - Cadastrar Produto: Permite aos administradores adicionar novos produtos ao sistema.
  - Criar Lote: Permite aos administradores criar novos lotes para leilão.
  - Lotes Expirados: Mostra os lotes que expiraram e precisam ser encerrados ou cancelados.


# Usuários

Administrador = email: 'adm@leilaodogalpao.com.br', senha: 'password'
Outro Administrador = email: 'otheradm@leilaodogalpao.com.br', senha: 'password'
Usuário = email: 'user@email.com', senha: 'password'
Outro Usuário = email: 'otheruser@email.com', senha: 'password'

