using System.Threading.Tasks;
using System.Xml.Linq;

namespace Ernst.Api.Blend.Interfaces
{
    public interface IFeeService
    {
        Task<string> GetErnstFeeResponse(XElement feeServiceRequest);
    }
}
