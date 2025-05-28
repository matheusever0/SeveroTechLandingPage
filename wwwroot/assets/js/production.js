// SeveroTech Production JavaScript
class SeveroTechApp {
  constructor() {
    this.init();
  }

  init() {
    console.log('SeveroTech App initialized');
    this.setupEventListeners();
    this.setupLazyLoading();
    this.setupFormValidation();
  }

  setupEventListeners() {
    // Smooth scroll para links internos
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
      anchor.addEventListener('click', (e) => {
        e.preventDefault();
        const target = document.querySelector(anchor.getAttribute('href'));
        if (target) {
          target.scrollIntoView({
            behavior: 'smooth',
            block: 'start'
          });
        }
      });
    });

    // Back to top button
    const backToTop = document.querySelector('.back-to-top');
    if (backToTop) {
      window.addEventListener('scroll', () => {
        if (window.pageYOffset > 300) {
          backToTop.style.display = 'block';
        } else {
          backToTop.style.display = 'none';
        }
      });
    }
  }

  setupLazyLoading() {
    const images = document.querySelectorAll('img[data-src]');
    if (images.length === 0) return;

    const imageObserver = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          const img = entry.target;
          img.src = img.dataset.src;
          img.classList.add('loaded');
          img.removeAttribute('data-src');
          imageObserver.unobserve(img);
        }
      });
    }, {
      rootMargin: '50px'
    });

    images.forEach(img => imageObserver.observe(img));
  }

  setupFormValidation() {
    const forms = document.querySelectorAll('form');
    
    forms.forEach(form => {
      form.addEventListener('submit', (e) => {
        if (!this.validateForm(form)) {
          e.preventDefault();
          this.showFormError('Por favor, preencha todos os campos obrigatÃ³rios.');
        }
      });

      // ValidaÃ§Ã£o em tempo real
      const inputs = form.querySelectorAll('input[required], textarea[required]');
      inputs.forEach(input => {
        input.addEventListener('blur', () => {
          this.validateField(input);
        });
      });
    });
  }

  validateForm(form) {
    const requiredFields = form.querySelectorAll('[required]');
    let isValid = true;

    requiredFields.forEach(field => {
      if (!this.validateField(field)) {
        isValid = false;
      }
    });

    return isValid;
  }

  validateField(field) {
    const value = field.value.trim();
    const isValid = value.length > 0;

    // ValidaÃ§Ã£o de email
    if (field.type === 'email' && value) {
      const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      if (!emailRegex.test(value)) {
        this.showFieldError(field, 'Digite um email vÃ¡lido');
        return false;
      }
    }

    if (isValid) {
      this.clearFieldError(field);
    } else {
      this.showFieldError(field, 'Este campo Ã© obrigatÃ³rio');
    }

    return isValid;
  }

  showFieldError(field, message) {
    field.style.borderColor = '#ef4444';
    
    let errorDiv = field.parentNode.querySelector('.error-message');
    if (!errorDiv) {
      errorDiv = document.createElement('div');
      errorDiv.className = 'error-message';
      errorDiv.style.color = '#ef4444';
      errorDiv.style.fontSize = '0.875rem';
      errorDiv.style.marginTop = '0.25rem';
      field.parentNode.appendChild(errorDiv);
    }
    errorDiv.textContent = message;
  }

  clearFieldError(field) {
    field.style.borderColor = '';
    const errorDiv = field.parentNode.querySelector('.error-message');
    if (errorDiv) {
      errorDiv.remove();
    }
  }

  showFormError(message) {
    // Criar ou atualizar mensagem de erro do formulÃ¡rio
    const existingError = document.querySelector('.form-error');
    if (existingError) {
      existingError.textContent = message;
      return;
    }

    const errorDiv = document.createElement('div');
    errorDiv.className = 'form-error';
    errorDiv.style.cssText = `
      background: #fee2e2;
      color: #991b1b;
      padding: 1rem;
      border-radius: 0.5rem;
      margin: 1rem 0;
      border: 1px solid #fecaca;
    `;
    errorDiv.textContent = message;

    const form = document.querySelector('form');
    if (form) {
      form.insertBefore(errorDiv, form.firstChild);
      
      // Remover apÃ³s 5 segundos
      setTimeout(() => {
        errorDiv.remove();
      }, 5000);
    }
  }

  // Utilities
  debounce(func, wait) {
    let timeout;
    return function executedFunction(...args) {
      const later = () => {
        clearTimeout(timeout);
        func(...args);
      };
      clearTimeout(timeout);
      timeout = setTimeout(later, wait);
    };
  }
}

// Initialize when DOM is ready
if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', () => {
    window.severoTechApp = new SeveroTechApp();
  });
} else {
  window.severoTechApp = new SeveroTechApp();
}
