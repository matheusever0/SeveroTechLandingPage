using Microsoft.AspNetCore.Mvc.RazorPages;
using SeveroTechLanding.Extensions;

namespace SeveroTechLanding.Pages
{
    public class IndexModel : PageModel
    {
        private readonly ILogger<IndexModel> _logger;

        public IndexModel(ILogger<IndexModel> logger)
        {
            _logger = logger;
        }

        public void OnGet()
        {
            this.SetupViewDataTitleFromUrl();

        }
    }
}
