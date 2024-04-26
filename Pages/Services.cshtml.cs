using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;

using SeveroTechLanding.Extensions;
namespace SeveroTechLanding.Pages
{
    public class ServicesModel : PageModel
    {
        public void OnGet()
        {
            this.SetupViewDataTitleFromUrl();
        }
    }
}
