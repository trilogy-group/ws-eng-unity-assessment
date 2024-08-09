# Constants
$ASSESSMENT_TYPE = "unity-game-development"
$ASSESSMENT_VERSION = "v2"
$encodedUrl = 'iyuja327ulc6hq3xsypufut7bh0lygdq.ynzoqn-hey.hf-rnfg-1.ba.njf'
$decodedUrl = -join ($encodedUrl.ToCharArray() | ForEach-Object {
    if ($_ -match '[a-zA-Z]') {
        $base = if ($_ -cmatch '[A-Z]') { 'A' } else { 'a' }
        [char]((([byte][char]$_ - [byte][char]$base + 13) % 26) + [byte][char]$base)
    } else { $_ }
})
$API_URL = "https://$decodedUrl"

# Get user info from git
$NAME = git config user.name
$EMAIL = git config user.email

# Prompt for user input
$INPUT_NAME = Read-Host "Enter your name [$NAME]"
$NAME = if ($INPUT_NAME) { $INPUT_NAME } else { $NAME }

$INPUT_EMAIL = Read-Host "Enter your email [$EMAIL]"
$EMAIL = if ($INPUT_EMAIL) { $INPUT_EMAIL } else { $EMAIL }

# Add all changes and commit
git add --all
git commit --allow-empty -am "chore(jenga): Prepares submission."

# Create a zip archive including the specified directories and root-level files
$OUTPUT_FILE = "submission_$($NAME -replace '[^a-zA-Z0-9+._-]', '').zip"
git archive --format=zip --output="$OUTPUT_FILE" HEAD Assets Packages ProjectSettings Demo

Write-Host "Submission archive created: $OUTPUT_FILE"

# Confirm zip file is correct
Write-Host "Please review the created zip file: $OUTPUT_FILE"
$CONFIRM = Read-Host "Is the zip file correct and ready for submission? [y/N]"
if ($CONFIRM -notmatch '^[yY]$') {
    Write-Host "Submission canceled."
    exit 0
}

# Submit the zip file
$SIZE = (Get-Item $OUTPUT_FILE).Length
$JSON_BODY = @{
    name = $NAME
    email = $EMAIL
    size = $SIZE
    type = $ASSESSMENT_TYPE
} | ConvertTo-Json

$UPLOAD_INFO = Invoke-RestMethod -Uri $API_URL -Method Post -Body $JSON_BODY -ContentType "application/json"
$UPLOAD_URL = $UPLOAD_INFO.upload.url
$UPLOAD_FIELDS = $UPLOAD_INFO.upload.fields

$fileBytes = [System.IO.File]::ReadAllBytes($OUTPUT_FILE)
$fileEnc = [System.Text.Encoding]::GetEncoding('ISO-8859-1').GetString($fileBytes)

$boundary = [System.Guid]::NewGuid().ToString()
$LF = "`r`n"
$bodyLines = @()

foreach ($field in $UPLOAD_FIELDS.PSObject.Properties) {
    $bodyLines += "--$boundary"
    $bodyLines += "Content-Disposition: form-data; name=`"$($field.Name)`""
    $bodyLines += ""
    $bodyLines += $field.Value
}

$bodyLines += "--$boundary"
$bodyLines += "Content-Disposition: form-data; name=`"file`"; filename=`"$OUTPUT_FILE`""
$bodyLines += "Content-Type: application/zip"
$bodyLines += ""
$bodyLines += $fileEnc
$bodyLines += "--$boundary--"

$body = $bodyLines -join $LF

Invoke-RestMethod -Uri $UPLOAD_URL -Method Post -ContentType "multipart/form-data; boundary=$boundary" -Body $body

$SUBMISSION_ID = $UPLOAD_INFO.submissionId
Write-Host "Submission successful, ID: $SUBMISSION_ID"
Write-Host "Please copy-paste this ID into the Crossover assessment page. You may resubmit your work as many times as you need, but only the submission with the ID recorded into the Crossover assessment page will be considered."