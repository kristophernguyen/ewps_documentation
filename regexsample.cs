using System;
using System.Text.RegularExpressions;

class Program
{
    static void Main()
    {
        string[] logText = new string[]
        {
            "11:27:50,154 custom_status INFO Successfully perform transfer job.",
            "11:27:50,142 another_status WARN Trying to get file meta info ...",
            "11:27:16,617 custom_status ERROR Successfully obtain file - finiq211.sas7bdat"
        };

        string pattern = @"^(\d{2}:\d{2}:\d{2},\d{3})\s+(\w+)\s+(INFO|WARN|ERROR)\s+(.+)$";

        foreach (string line in logText)
        {
            Match match = Regex.Match(line, pattern);
            if (match.Success)
            {
                string time = match.Groups[1].Value;
                string statusField = match.Groups[2].Value;
                string status = match.Groups[3].Value;
                string message = match.Groups[4].Value;

                Console.WriteLine($"Line Status: {status}, Time: {time}, Status Field: {statusField}, Message: {message}");
            }
            else
            {
                Console.WriteLine("Pattern not matched for line: " + line);
            }
        }
    }
}
