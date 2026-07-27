# RealFit 💪

**Unidade Curricular:** Computação Móvel (2025-2026)  
**Instituição:** Escola Superior de Tecnologia de Setúbal – IPS
**Equipa (Grupo 6 - PL1):**  
* Arlindo Mino Chicala
* Caram Intai Baticam Cassamá
* Luis Ferreira

---

## 📱 Definição do Conceito
O **RealFit** é uma aplicação móvel interativa e empática de fitness, desenhada para funcionar como um diário pessoal de bem-esta. Desconstruindo a obsessão pela perfeição física e pelas métricas agressivas das apps tradicionais, o RealFit respeita as limitações físicas e a saúde mental do utilizador. O sistema foca-se na consistência, adaptando as rotinas diárias aos níveis de energia e humor de jovens adultos e indivíduos com rotinas irregulares ou sedentárias. 

---

## 🔗 Links Importantes
* **Vídeo de Demonstração:** [Inserir Link do YouTube/Drive aqui]
* **Design, Mockups e Esquema de Navegação (Figma):** https://www.figma.com/design/gT1butpAWxAtIuBwRnREy5/IPM_MediaFidelidade?node-id=0-1&t=DwX9caQGXCHertks-1

---

## ⚙️ Cumprimento dos Requisitos Mínimos (IPS)

1. **Autenticação e Registo:** Implementado com **Firebase Auth** (Email/Password), estando a UI preparada para futura integração de biometria e autenticação Google.
2. **Sistema de Notificações:** Implementação de push notifications com um tom de comunicação empático focado no autocuidado.
3. **Integração com API Externa:** Integração com a **API Pública Wger** para geração dinâmica de rotinas de treino baseadas no estado de espírito do utilizador.
4. **Base de Dados Remota:** Implementado com **Firebase Realtime Database** para gerir os perfis, o histórico de consistência (conquistas) e as interações sociais.

---
 
## 🛠️ Funcionalidades Implementadas

O projeto foi construído em **Flutter**, seguindo boas práticas de modularização de código (separação entre UI e Lógica/Serviços) e integra as seguintes funcionalidades centrais:

* **Autenticação e Registo :** Sistema de entrada rápido que permite o registo e login convencionais.
* **Configuração e Gestão de Objetivos :** Processo de *onboarding* não invasivo que recolhe as características físicas e metas do utilizador para personalizar o plano de base.
* **Registo Diário de Bem-Estar / Check-in Empático:** Interface visual baseada em seleção rápida  que avalia o nível de energia e humor diário, adaptando dinamicamente a sugestão de treino (ex: sugerir alongamentos em dias de exaustão).
* **Gestão e Execução de Treinos :** Sugestão proativa de rotinas com total autonomia para o utilizador substituir a recomendação por um treino gerado manualmente.

* **Interação Social e Suporte de Pares (F05):** Feed de partilha de progresso não competitivo, onde os utilizadores podem celebrar marcos de consistência e "enviar força" aos seus companheiros.


---

## 🚀 Como Instalar e Correr o Projeto

1. Certifique-se de que tem o ambiente **Flutter** configurado na sua máquina.
2. Clone este repositório:
   git clone https://github.com/ArlindoIps/RealFit.git

Aceda à pasta do projeto:
    cd realfit
Instale as dependências necessárias:
    flutter pub get
Execute a aplicação num emulador ou dispositivo físico:
    flutter run