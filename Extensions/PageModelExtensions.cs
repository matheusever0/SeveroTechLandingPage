﻿using Microsoft.AspNetCore.Mvc.RazorPages;

namespace SeveroTechLanding.Extensions
{
    public static class PageModelExtensions
    {
        public static void SetupViewDataTitleFromUrl(this PageModel pageModel)
        {
            var currentUrl = pageModel.HttpContext.GetCurrentUrl();
            var currentCshtml = currentUrl.ToCshtmlName();
            var currentTitle = currentCshtml.ToTitle();
            pageModel.ViewData["Title"] = currentTitle;

            var currentPageName = currentUrl.ToPageFolderName();
            if (currentPageName.EndsWith('y'))
            {
                currentPageName = currentPageName.Substring(0, currentPageName.Length - 1) + "ies";
            }

            if(currentPageName == "Services")
            {
                currentPageName = "Serviços";
                currentCshtml = "Serviços";
            }

            pageModel.ViewData["PageFolderName"] = currentPageName;
            pageModel.ViewData["CshtmlName"] = currentCshtml;
        }
    }
}
