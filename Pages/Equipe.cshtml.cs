using Microsoft.AspNetCore.Mvc.RazorPages;

using SeveroTechLanding.Extensions;
namespace SeveroTechLanding.Pages
{
    public class EquipeModel : PageModel
    {
        public void OnGet()
        {
            this.SetupViewDataTitleFromUrl();
        }
    }
}
