# Ziwi API on ASP.NET Core MVC

This project requires .NET Core SDK 2.2 or later.
See https://dotnet.microsoft.com/learn/dotnet/hello-world-tutorial/install

Run `dotnet run` to start the API.

> If you get an *'Unable to configure HTTPS endpoint'* error, then run
`dotnet dev-certs https`. See https://go.microsoft.com/fwlink/?linkid=848054
for more info.

Test it is working, open in a browser or `curl`:

```Shell
# The default HTTPS port is 5001, change as needed
curl --insecure --request GET --url "https://localhost:5001/"
```Shell
