#!/usr/bin/env bash
# publicar.sh — faz commit e push do painel para o GitHub
# (Cloudflare Pages detecta o push e redeploya automaticamente)

set -e

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$REPO_DIR"

# Mensagem de commit automática com data/hora
MSG="update: ${1:-dados $(date '+%Y-%m-%d %H:%M')}"

echo "📁 Diretório: $REPO_DIR"
echo "💬 Commit: $MSG"
echo ""

git add .
git commit -m "$MSG" || echo "(nada novo para commitar)"
git push

echo ""
echo "✅ Enviado! O Cloudflare Pages vai redesployar em ~30 segundos."
echo "   Acompanhe em: https://dash.cloudflare.com → Pages → seu projeto"
