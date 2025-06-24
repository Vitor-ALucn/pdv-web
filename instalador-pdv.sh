#!/bin/bash

echo "🚀 Iniciando instalação do PDV Web..."

# Verifica se está como root
if [ "$EUID" -ne 0 ]; then
  echo "⚠️ Execute como root: sudo ./instalador-pdv.sh"
  exit 1
fi

# Variáveis
APP_DIR="/opt/pdv-web"
REPO_URL="https://github.com/seuusuario/pdv-web.git" 

# Criar diretório base
mkdir -p $APP_DIR
cd $APP_DIR || { echo "❌ Erro ao acessar $APP_DIR"; exit 1; }

# Baixar repositório
echo "📥 Clonando repositório..."
git clone $REPO_URL .
if [ $? -ne 0 ]; then
  echo "❌ Erro ao clonar repositório"
  exit 1
fi

# Backend Setup
echo "🔧 Configurando backend (Django API REST)..."

cd $APP_DIR/backend || { echo "❌ Diretório backend não encontrado"; exit 1; }

# Criar ambiente virtual
python3 -m venv venv
source venv/bin/activate

# Instalar dependências
pip install -r requirements.txt

# Migrar banco e coletar static
python manage.py migrate
python manage.py collectstatic --noinput

# Frontend Setup
echo "🧩 Configurando frontend (React App)..."

cd $APP_DIR/frontend || { echo "❌ Diretório frontend não encontrado"; exit 1; }

# Instalar dependências do React
npm install

# Build inicial (opcional)
npm run build

# Mensagem final
echo "✅ PDV Web instalado com sucesso!"
echo ""
echo "🔧 Como rodar:"
echo "Backend: cd /opt/pdv-web/backend && source venv/bin/activate && python manage.py runserver"
echo "Frontend: cd /opt/pdv-web/frontend && npm run dev"
