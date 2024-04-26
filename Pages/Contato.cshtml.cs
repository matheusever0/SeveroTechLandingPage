using Microsoft.AspNetCore.Mvc.RazorPages;
using SeveroTechLanding.Extensions;

namespace SeveroTechLanding.Pages
{
    public class ContactModel : PageModel
    {
        public void OnGet()
        {
            this.SetupViewDataTitleFromUrl();
        }
    }
}
