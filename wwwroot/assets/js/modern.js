/* =========================================================================
   SEVEROTECH MODERN JAVASCRIPT - InteraÃ§Ãµes e animaÃ§Ãµes
   ========================================================================= */

class SeveroTechModern {
  constructor() {
    this.init();
  }

  init() {
    this.setupThemeToggle();
    this.setupScrollAnimations();
    this.setupFormValidation();
    this.setupParallax();
    this.setupSmoothScroll();
    this.setupCounters();
    this.setupTypewriter();
    this.setupParticles();
  }

  // Toggle de tema dark/light
  setupThemeToggle() {
    const themeToggle = document.querySelector('.theme-toggle');
    const currentTheme = localStorage.getItem('theme') || 'light';
    
    document.documentElement.setAttribute('data-theme', currentTheme);
    
    if (themeToggle) {
      themeToggle.addEventListener('click', () => {
        const theme = document.documentElement.getAttribute('data-theme');
        const newTheme = theme === 'dark' ? 'light' : 'dark';
        
        document.documentElement.setAttribute('data-theme', newTheme);
        localStorage.setItem('theme', newTheme);
        
        // AnimaÃ§Ã£o suave
        document.body.style.transition = 'all 0.3s ease';
        setTimeout(() => {
          document.body.style.transition = '';
        }, 300);
      });
    }
  }

  // AnimaÃ§Ãµes no scroll
  setupScrollAnimations() {
    const observerOptions = {
      threshold: 0.1,
      rootMargin: '0px 0px -50px 0px'
    };

    const observer = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          entry.target.classList.add('animate-in');
        }
      });
    }, observerOptions);

    document.querySelectorAll('.animate-on-scroll').forEach(el => {
      observer.observe(el);
    });
  }

  // ValidaÃ§Ã£o de formulÃ¡rio em tempo real
  setupFormValidation() {
    const forms = document.querySelectorAll('.form-modern');
    
    forms.forEach(form => {
      const inputs = form.querySelectorAll('.form-input-modern');
      
      inputs.forEach(input => {
        input.addEventListener('blur', () => this.validateField(input));
        input.addEventListener('input', () => this.clearValidation(input));
      });
      
      form.addEventListener('submit', (e) => this.handleFormSubmit(e));
    });
  }

  validateField(field) {
    const value = field.value.trim();
    const type = field.type;
    let isValid = true;
    let message = '';

    // ValidaÃ§Ãµes bÃ¡sicas
    if (field.hasAttribute('required') && !value) {
      isValid = false;
      message = 'Este campo Ã© obrigatÃ³rio';
    } else if (type === 'email' && value && !this.isValidEmail(value)) {
      isValid = false;
      message = 'Digite um email vÃ¡lido';
    } else if (type === 'tel' && value && !this.isValidPhone(value)) {
      isValid = false;
      message = 'Digite um telefone vÃ¡lido';
    }

    this.showFieldValidation(field, isValid, message);
    return isValid;
  }

  showFieldValidation(field, isValid, message) {
    field.classList.remove('is-valid', 'is-invalid');
    field.classList.add(isValid ? 'is-valid' : 'is-invalid');
    
    let feedback = field.parentNode.querySelector('.form-feedback-modern');
    if (!feedback) {
      feedback = document.createElement('div');
      feedback.className = 'form-feedback-modern';
      field.parentNode.appendChild(feedback);
    }
    
    feedback.textContent = message;
    feedback.className = orm-feedback-modern ;
  }

  clearValidation(field) {
    field.classList.remove('is-valid', 'is-invalid');
    const feedback = field.parentNode.querySelector('.form-feedback-modern');
    if (feedback) {
      feedback.textContent = '';
    }
  }

  handleFormSubmit(e) {
    e.preventDefault();
    const form = e.target;
    const inputs = form.querySelectorAll('.form-input-modern');
    let isFormValid = true;

    inputs.forEach(input => {
      if (!this.validateField(input)) {
        isFormValid = false;
      }
    });

    if (isFormValid) {
      this.submitForm(form);
    }
  }

  async submitForm(form) {
    const submitBtn = form.querySelector('button[type="submit"]');
    const originalText = submitBtn.textContent;
    
    submitBtn.textContent = 'Enviando...';
    submitBtn.disabled = true;
    
    try {
      // Simular envio (substitua pela lÃ³gica real)
      await new Promise(resolve => setTimeout(resolve, 2000));
      
      this.showNotification('Mensagem enviada com sucesso!', 'success');
      form.reset();
    } catch (error) {
      this.showNotification('Erro ao enviar mensagem. Tente novamente.', 'error');
    } finally {
      submitBtn.textContent = originalText;
      submitBtn.disabled = false;
    }
  }

  // Efeito parallax sutil
  setupParallax() {
    const parallaxElements = document.querySelectorAll('.parallax');
    
    window.addEventListener('scroll', () => {
      const scrolled = window.pageYOffset;
      
      parallaxElements.forEach(element => {
        const rate = scrolled * -0.5;
        element.style.transform = 	ranslateY(px);
      });
    });
  }

  // Scroll suave
  setupSmoothScroll() {
    document.querySelectorAll('a[href^="#"]:not([href="#"])').forEach(link => {
      link.addEventListener('click', (e) => {
        e.preventDefault();
        const target = document.querySelector(link.getAttribute('href'));
        if (target) {
          target.scrollIntoView({
            behavior: 'smooth',
            block: 'start'
          });
        }
      });
    });
  }

  // Contador animado
  setupCounters() {
    const counters = document.querySelectorAll('.counter');
    
    const countObserver = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          this.animateCounter(entry.target);
          countObserver.unobserve(entry.target);
        }
      });
    });
    
    counters.forEach(counter => countObserver.observe(counter));
  }

  animateCounter(element) {
    const target = parseInt(element.getAttribute('data-target'));
    const duration = 2000;
    const increment = target / (duration / 16);
    let current = 0;
    
    const timer = setInterval(() => {
      current += increment;
      if (current >= target) {
        current = target;
        clearInterval(timer);
      }
      element.textContent = Math.floor(current);
    }, 16);
  }

  // Efeito de digitaÃ§Ã£o
  setupTypewriter() {
    const typewriters = document.querySelectorAll('.typewriter');
    
    typewriters.forEach(element => {
      const text = element.textContent;
      element.textContent = '';
      let i = 0;
      
      const timer = setInterval(() => {
        if (i < text.length) {
          element.textContent += text.charAt(i);
          i++;
        } else {
          clearInterval(timer);
        }
      }, 100);
    });
  }

  // PartÃ­culas animadas
  setupParticles() {
    const particleContainer = document.querySelector('.hero-particles');
    if (!particleContainer) return;
    
    for (let i = 0; i < 20; i++) {
      const particle = document.createElement('div');
      particle.className = 'particle';
      particle.style.left = Math.random() * 100 + '%';
      particle.style.animationDelay = Math.random() * 15 + 's';
      particle.style.animationDuration = (15 + Math.random() * 10) + 's';
      particleContainer.appendChild(particle);
    }
  }

  // NotificaÃ§Ãµes
  showNotification(message, type = 'info') {
    const notification = document.createElement('div');
    notification.className = 
otification notification-;
    notification.textContent = message;
    
    document.body.appendChild(notification);
    
    setTimeout(() => {
      notification.classList.add('show');
    }, 100);
    
    setTimeout(() => {
      notification.classList.remove('show');
      setTimeout(() => {
        document.body.removeChild(notification);
      }, 300);
    }, 3000);
  }

  // UtilitÃ¡rios
  isValidEmail(email) {
    return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
  }

  isValidPhone(phone) {
    return /^[\+]?[1-9][\d]{0,15}$/.test(phone.replace(/\s/g, ''));
  }
}

// Inicializar quando o DOM estiver carregado
document.addEventListener('DOMContentLoaded', () => {
  new SeveroTechModern();
});

// AnimaÃ§Ãµes CSS extras
const style = document.createElement('style');
style.textContent = 
  .animate-on-scroll {
    opacity: 0;
    transform: translateY(30px);
    transition: all 0.6s ease-out;
  }
  
  .animate-on-scroll.animate-in {
    opacity: 1;
    transform: translateY(0);
  }
  
  .notification {
    position: fixed;
    top: 20px;
    right: 20px;
    padding: 1rem 1.5rem;
    border-radius: var(--radius-lg);
    color: white;
    font-weight: 500;
    z-index: 9999;
    transform: translateX(100%);
    transition: transform 0.3s ease;
  }
  
  .notification.show {
    transform: translateX(0);
  }
  
  .notification-success {
    background: #10b981;
  }
  
  .notification-error {
    background: #ef4444;
  }
  
  .notification-info {
    background: var(--color-primary);
  }
;
document.head.appendChild(style);
