using Ernst.Api.Blend.Entities;
using Microsoft.AspNetCore.Mvc;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace Ernst.API.Blend.Interfaces
{
	public interface IQuoteService
    {
        Task<ActionResult<string>> Transform_BlendFeeReqToErnstFeeReq(BlendFeeRequest ernstFeeResponse);

        Task<ActionResult<string>> TransformErnstFeeResponse(XElement ernstFeeResponse);
    }
}
