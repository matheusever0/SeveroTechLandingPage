using Microsoft.AspNetCore.Mvc;
using SeveroTechLanding.Models;
using SeveroTechLanding.Services;

namespace SeveroTechLanding.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ContactController : ControllerBase
    {
        private readonly IEmailService _emailService;
        private readonly ILogger<ContactController> _logger;

        public ContactController(IEmailService emailService, ILogger<ContactController> logger)
        {
            _emailService = emailService;
            _logger = logger;
        }

        [HttpPost]
        public async Task<ActionResult<ContactResponse>> Post([FromBody] ContactModel contact)
        {
            try
            {
                if (!ModelState.IsValid)
                {
                    var errors = ModelState.Values
                        .SelectMany(v => v.Errors)
                        .Select(e => e.ErrorMessage)
                        .ToList();

                    return BadRequest(new ContactResponse
                    {
                        Success = false,
                        Message = string.Join(", ", errors)
                    });
                }

                contact.IPAddress = HttpContext.Connection.RemoteIpAddress?.ToString();
                contact.UserAgent = HttpContext.Request.Headers["User-Agent"].ToString();
                contact.CreatedAt = DateTime.Now;

                if (IsSpam(contact))
                {
                    _logger.LogWarning("PossÃ­vel spam detectado de {IP}: {Email}", contact.IPAddress, contact.Email);
                    return Ok(new ContactResponse { Success = true, Message = "Mensagem enviada com sucesso!" });
                }

                var emailSent = await _emailService.SendContactEmailAsync(contact);

                return Ok(new ContactResponse
                {
                    Success = emailSent,
                    Message = emailSent ? "Mensagem enviada com sucesso! Entraremos em contato em breve." 
                                       : "Ocorreu um erro ao enviar a mensagem. Tente novamente.",
                    Id = Guid.NewGuid().ToString()
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Erro ao processar contato");
                return StatusCode(500, new ContactResponse
                {
                    Success = false,
                    Message = "Erro interno do servidor. Tente novamente mais tarde."
                });
            }
        }

        private bool IsSpam(ContactModel contact)
        {
            var spamKeywords = new[] { "bitcoin", "crypto", "loan", "viagra", "casino" };
            var content = (contact.Message + " " + contact.Subject).ToLower();
            
            return spamKeywords.Any(keyword => content.Contains(keyword)) ||
                   contact.Message.Length < 10 ||
                   contact.Name.Length < 2;
        }
    }
}
