using System.ComponentModel.DataAnnotations;

namespace SeveroTechLanding.Models
{
    public class ContactModel
    {
        [Required(ErrorMessage = "Nome Ã© obrigatÃ³rio")]
        [StringLength(100, ErrorMessage = "Nome deve ter no mÃ¡ximo 100 caracteres")]
        public string Name { get; set; } = string.Empty;

        [Required(ErrorMessage = "Email Ã© obrigatÃ³rio")]
        [EmailAddress(ErrorMessage = "Email invÃ¡lido")]
        public string Email { get; set; } = string.Empty;

        [Required(ErrorMessage = "Telefone Ã© obrigatÃ³rio")]
        [Phone(ErrorMessage = "Telefone invÃ¡lido")]
        public string Phone { get; set; } = string.Empty;

        [Required(ErrorMessage = "Assunto Ã© obrigatÃ³rio")]
        [StringLength(200, ErrorMessage = "Assunto deve ter no mÃ¡ximo 200 caracteres")]
        public string Subject { get; set; } = string.Empty;

        [Required(ErrorMessage = "Mensagem Ã© obrigatÃ³ria")]
        [StringLength(2000, ErrorMessage = "Mensagem deve ter no mÃ¡ximo 2000 caracteres")]
        public string Message { get; set; } = string.Empty;

        public string? Company { get; set; }
        public string? Service { get; set; }
        public DateTime CreatedAt { get; set; } = DateTime.Now;
        public string? IPAddress { get; set; }
        public string? UserAgent { get; set; }
    }

    public class ContactResponse
    {
        public bool Success { get; set; }
        public string Message { get; set; } = string.Empty;
        public string? Id { get; set; }
    }
}
