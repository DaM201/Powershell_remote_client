param (
    [string]$serverIP = "127.0.0.1",
    [int]$serverPort = 5555
)

$client = [System.Net.Sockets.TcpClient]::new()
$client.Connect($serverIP, $serverPort)
$stream = $client.GetStream()
$reader = [System.IO.StreamReader]::new($stream)
$writer = [System.IO.StreamWriter]::new($stream)

function SendMessage {
    param (
        [string]$message
    )
    $writer.WriteLine($message)
    $writer.Flush()
}

function ReceiveMessage {
    $data = $reader.ReadLine()
    Write-Host ". $data"
}

# Example usage
SendMessage "clear"

# Wait for the server response
ReceiveMessage

# Allow the user to send messages to the server
while ($true) {
    $userInput = Read-Host "Gripper@powershell"
    if ($userInput -eq 'exit') {
        break
    }
    SendMessage $userInput
    ReceiveMessage
}

$client.Close()

