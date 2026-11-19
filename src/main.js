import "./style.css";

async function carregarStatus() {
  try {
    const resposta = await fetch("http://localhost:3000/api/health");
    const dados = await resposta.json();

    document.querySelector("#app").innerHTML = `
      <h1>SindiCD</h1>
      <h2>Status da API: ${dados.status}</h2>
    `;
  } catch (erro) {
    document.querySelector("#app").innerHTML = `
      <h1>SindiCD</h1>
      <h2>Erro ao conectar com a API</h2>
    `;
    console.error(erro);
  }
}

carregarStatus();
