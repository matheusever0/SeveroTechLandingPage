/* =========================================================================
   SEVEROTECH CHATBOT JAVASCRIPT - Sistema de chat inteligente
   ========================================================================= */

class SeveroTechChatbot {
  constructor() {
    this.isOpen = false;
    this.responses = {
      'ola': 'OlÃ¡! Seja bem-vindo Ã  SeveroTech! Como posso ajudÃ¡-lo hoje?',
      'servicos': 'Oferecemos desenvolvimento web, aplicativos mÃ³veis e sistemas personalizados.',
      'preco': 'Nossos preÃ§os variam conforme o projeto. Gostaria de um orÃ§amento?',
      'contato': 'VocÃª pode entrar em contato pelo WhatsApp ou email.',
      'default': 'Interessante! Deixe-me conectar vocÃª com um especialista.'
    };
    
    this.init();
  }

  init() {
    this.createChatbotHTML();
    this.setupEventListeners();
    this.addWelcomeMessage();
  }

  createChatbotHTML() {
    const chatbotHTML = `
      <div class="chatbot-container">
        <button class="chatbot-trigger" id="chatbot-trigger">
          <i class="fas fa-comments"></i>
        </button>
        
        <div class="chatbot-window" id="chatbot-window">
          <div class="chatbot-header">
            <h4>Assistente SeveroTech</h4>
            <p>Online agora</p>
          </div>
          
          <div class="chatbot-messages" id="chatbot-messages"></div>
          
          <div class="chatbot-input">
            <input type="text" id="chatbot-input" placeholder="Digite sua mensagem...">
            <button class="chatbot-send" id="chatbot-send">
              <i class="fas fa-paper-plane"></i>
            </button>
          </div>
        </div>
      </div>
    `;
    
    document.body.insertAdjacentHTML('beforeend', chatbotHTML);
  }

  setupEventListeners() {
    const trigger = document.getElementById('chatbot-trigger');
    const sendBtn = document.getElementById('chatbot-send');
    const input = document.getElementById('chatbot-input');

    trigger.addEventListener('click', () => this.toggleChat());
    sendBtn.addEventListener('click', () => this.sendMessage());
    
    input.addEventListener('keypress', (e) => {
      if (e.key === 'Enter') {
        this.sendMessage();
      }
    });
  }

  toggleChat() {
    const trigger = document.getElementById('chatbot-trigger');
    const window = document.getElementById('chatbot-window');
    
    this.isOpen = !this.isOpen;
    
    trigger.classList.toggle('active', this.isOpen);
    window.classList.toggle('active', this.isOpen);
    
    if (this.isOpen) {
      document.getElementById('chatbot-input').focus();
    }
  }

  sendMessage() {
    const input = document.getElementById('chatbot-input');
    const message = input.value.trim();
    
    if (!message) return;
    
    this.addMessage(message, 'user');
    input.value = '';
    
    setTimeout(() => {
      const response = this.generateResponse(message);
      this.addMessage(response, 'bot');
    }, 1000);
  }

  addMessage(text, sender) {
    const messagesContainer = document.getElementById('chatbot-messages');
    
    const messageHTML = `<div class="message ${sender}">${text}</div>`;
    messagesContainer.insertAdjacentHTML('beforeend', messageHTML);
    messagesContainer.scrollTop = messagesContainer.scrollHeight;
  }

  generateResponse(message) {
    const lowerMessage = message.toLowerCase();
    
    if (lowerMessage.includes('olÃ¡') || lowerMessage.includes('oi')) {
      return this.responses['ola'];
    } else if (lowerMessage.includes('serviÃ§o')) {
      return this.responses['servicos'];
    } else if (lowerMessage.includes('preÃ§o')) {
      return this.responses['preco'];
    } else if (lowerMessage.includes('contato')) {
      return this.responses['contato'];
    } else {
      return this.responses['default'];
    }
  }

  addWelcomeMessage() {
    setTimeout(() => {
      this.addMessage('ðŸ‘‹ OlÃ¡! Sou o assistente virtual da SeveroTech. Como posso ajudÃ¡-lo?', 'bot');
    }, 1000);
  }
}

document.addEventListener('DOMContentLoaded', () => {
  window.severoTechChatbot = new SeveroTechChatbot();
});
