# DNS Propagation Checker

This script checks the DNS propagation of a domain by querying a list of DNS servers for the domain's A records.

## Usage

```bash
./check-dns-propagation.sh <domain>
```

Replace <domain> with the domain you want to check. The domain should be a bare domain, not a subdomain. For example, use example.com, not www.example.com.

## How It Works

The script sends DNS queries to a list of DNS servers and prints the A records that each server returns for the domain. This can be useful for checking the DNS propagation of a domain after changing its DNS records.

The list of DNS servers includes popular public DNS servers like Google DNS (8.8.8.8), Cloudflare DNS (1.1.1.1), and Quad9 (9.9.9.9), among others.

## Requirements

This script requires the dig command, which is a part of the BIND DNS software package. On most Unix-based systems, you can install it with your package manager. For example, on Ubuntu, you can install it with sudo apt install dnsutils.

## Limitations

This script checks only the A records of the domain. It does not check other types of DNS records like AAAA, MX, or TXT records. These features will be added in the future probably.

## License

This script is released under the MIT license.
