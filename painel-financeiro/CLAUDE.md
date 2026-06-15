# Painel Financeiro — Documentação do Projeto

## Estrutura de arquivos

```
painel-financeiro/
├── index.html              # Painel (HTML + CSS + JS inline, sem dependências)
├── dados.json              # Todos os dados financeiros (extrato, cartão, agenda)
├── regras_categorizacao.json  # Fonte de verdade para categorias e regras de negócio
├── publicar.sh             # Script de deploy (git add + commit + push)
└── CLAUDE.md               # Este arquivo
```

## Convenções de dados (dados.json)

### Convenção de sinal
- **Positivo** = saída (gasto, despesa)
- **Negativo** = entrada (receita, recebimento)

### Chaves principais
| Chave | Descrição |
|---|---|
| `diary` | Extrato diário PF — lista de objetos `{date, transactions[]}` |
| `cardItems` | Resumo da fatura do cartão do mês corrente |
| `cardSpending` | Orçamentos por categoria do cartão |
| `sched` | Agenda PF — contas e recebimentos futuros |
| `azDiary` | Extrato diário PJ (prefixo `az`) |
| `azSched` | Agenda PJ |

### Estrutura de uma transação
```json
{
  "desc": "Mercado Extra",
  "amount": 347.80,
  "tag": "alimentação",
  "note": "Campo opcional para observações"
}
```

### Tags e comportamento no relatório "Pra onde foi"
- Tags com `showInReport: false` em `regras_categorizacao.json` são excluídas do relatório
- Tags com `isCardPayment: true` (tag `cartao`) são excluídas para evitar dupla contagem
- Tags com `isInternalTransfer: true` são excluídas (ex: `prolabore`)
- Entradas (amount < 0) sempre são excluídas do relatório de gastos

## Regras de negócio importantes

1. **Cartão de crédito**: o gasto real entra no `cardItems.categories`. A `fatura` aparece no `diary` com `tag: "cartao"` e é **excluída** dos resumos e do "Pra onde foi" para não duplicar.
2. **Empresa (PJ)**: usa chaves prefixadas com `az` (`azDiary`, `azSched`). Aparece na aba "Empresa" do painel.
3. **Transferências internas** (ex: pró-labore): listadas em `regras_categorizacao.json > internalTransfers` e excluídas dos relatórios.

## Como atualizar os dados

### Manualmente
Edite `dados.json` e rode `./publicar.sh` para redesployar.

### Com Open Finance (futuro)
O botão "Atualizar" no painel está preparado para chamar tools MCP do Pluggy (Open Finance). As tools usadas estão listadas no bloco `<script id="cowork-artifact-meta">` no `index.html`:
- `openfinance_list_transactions`
- `openfinance_get_credit_card_bill`
- `openfinance_force_sync`

## Deploy (Cloudflare Pages)

- Repositório: GitHub (configurar em `/publicar.sh`)
- Build command: *(nenhum — site estático)*
- Output directory: `/` (raiz)
- Branch de produção: `main`

Após configurar, cada `./publicar.sh` redesploya automaticamente em ~30s.

## Personalização rápida

Para adicionar uma conta ou banco novo:
1. Adicione em `regras_categorizacao.json > accounts`
2. Adicione transações em `dados.json > diary` (ou `azDiary` para PJ)

Para adicionar uma nova categoria:
1. Adicione a tag em `regras_categorizacao.json > tags`
2. Use a tag nas transações em `dados.json`

Para alterar orçamentos do cartão:
1. Edite os valores em `dados.json > cardSpending > budgets`
