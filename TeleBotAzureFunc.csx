using System.Net;

public static async Task<string> Run(GitEvent req, TraceWriter log)
{
    log.Info("C# HTTP trigger function processed a request.");

    await Req.GetAsync("https://api.telegram.org/bot/sendMessage?chat_id=&text="+ req.detailedMessage.text);
 
    return req.detailedMessage.text;    
}

public class GitEvent
{
    public DetailedMessage detailedMessage {get;set;}
    public class DetailedMessage
    {
        public string text {get;set;}
        public string html {get;set;}
        public string markdown {get;set;}
    }
}
public static class Req
{
    public static async Task<string> GetAsync(string uri)
    {
        HttpWebRequest request = (HttpWebRequest)WebRequest.Create(uri);
        request.AutomaticDecompression = DecompressionMethods.GZip | DecompressionMethods.Deflate;

        using(HttpWebResponse response = (HttpWebResponse)await request.GetResponseAsync())
        using(Stream stream = response.GetResponseStream())
        using(StreamReader reader = new StreamReader(stream))
        {
            return await reader.ReadToEndAsync();
        }
    }
}