using System.Net;
using System.Net.Mail;
using SeveroTechLanding.Models;

namespace SeveroTechLanding.Services
{
    public interface IEmailService
    {
        Task<bool> SendContactEmailAsync(ContactModel contact);
    }

    public class EmailService : IEmailService
    {
        private readonly IConfiguration _configuration;
        private readonly ILogger<EmailService> _logger;

        public EmailService(IConfiguration configuration, ILogger<EmailService> logger)
        {
            _configuration = configuration;
            _logger = logger;
        }

        public async Task<bool> SendContactEmailAsync(ContactModel contact)
        {
            try
            {
                var smtpSettings = _configuration.GetSection("SmtpSettings");
                
                using var client = new SmtpClient(smtpSettings["Host"])
                {
                    Port = int.Parse(smtpSettings["Port"] ?? "587"),
                    Credentials = new NetworkCredential(
                        smtpSettings["Username"], 
                        smtpSettings["Password"]
                    ),
                    EnableSsl = bool.Parse(smtpSettings["EnableSsl"] ?? "true")
                };

                var message = new MailMessage
                {
                    From = new MailAddress(smtpSettings["From"] ?? "", "SeveroTech"),
                    Subject = "Novo contato: " + contact.Subject,
                    Body = CreateEmailBody(contact),
                    IsBodyHtml = false
                };

                message.To.Add(smtpSettings["To"] ?? "contato@severotech.com.br");
                message.ReplyToList.Add(new MailAddress(contact.Email, contact.Name));

                await client.SendMailAsync(message);
                _logger.LogInformation("Email enviado com sucesso para {Email}", contact.Email);
                
                return true;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Erro ao enviar email para {Email}", contact.Email);
                return false;
            }
        }

        private string CreateEmailBody(ContactModel contact)
        {
            return $@"
NOVO CONTATO RECEBIDO - SEVEROTECH

Nome: {contact.Name}
Email: {contact.Email}
Telefone: {contact.Phone}
Empresa: {contact.Company ?? "NÃ£o informado"}
ServiÃ§o: {contact.Service ?? "NÃ£o informado"}
Assunto: {contact.Subject}

Mensagem:
{contact.Message}

---
Data: {contact.CreatedAt:dd/MM/yyyy HH:mm}
IP: {contact.IPAddress ?? "NÃ£o disponÃ­vel"}
";
        }
    }
}
