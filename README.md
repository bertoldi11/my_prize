# MyPrize

### Pra rodar esse projeto você precisa ter as seguintes dependencias instaladas:
Elixir 1.18.4-otp-28
Erlang 28.0.2
Postgresql

#### Caso tenha o asdf instalado, para baixar a versão do elixir e do erlang é so rodar o seguinte comando na raiz do projeto:

```bash
asdf install
```

Simples assim!

### Como rodar

Faça o clone desse projeto em um reposítorio de sua preferência.

Entre na pasta do projeto.

Pra criar o banco de dados, execute:

```bash
mix ecto.create
```

Rode as migrations:

```bash
mix ecto.migrate
```

Rode a aplicação:

```bash
mix phx.server
```

Pronto. A aplicação estará disponível em http://localhost:4000


### Funcionalidades

#### Cadastrar um usuário
Para cadastrar um usuário, faça uma chamada POST no endpoint `/api/account` usando o seguinte payload:

```json
{
    "email": "Email da pessoa usuária",
    "name": "Nome da pessoa usuária"
}
```

Todos os campos são obrigatórios

#### Cadastrar um novo sorteio
Para cadastrar um novo sorteio é necessário que a pessoa usuária dona do sorteio seja informada no payload.
Faça uma chamada POST no endpoint `/api/prize` usando um payload como o que esta abaixo

```json
{
    "name": "Meu sorteio",
    "description": "Breve descrição do torneio",
    "account_owner_id": "ID da pessoa usuária",
    "expiration_date": "2027-12-31"
}
```

Todos os campos são obrigatórios, exceto `description`

#### Participar de um sorteio
Para adicionar uma pessoa como participante de um sorteio, faça uma chama POST no endpoint `/api/prize/apply` passando o id da pessoa e o id do sorteio

```json
{
    "account_id": "ID da pessoa usuária", 
    "prize_id": "ID do torneio"
}
```

Todos os campos são obrigatórios

#### Consultar resultado de um sorteio
Para consultar o resultado de um sorteio, faça uma chamada GET ao endpoint `/api/prize/result/:prizeID` substituindo o `prizeID` pelo id e um sorteio.