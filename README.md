# ses-templates

These [AWS Simple Email Service (SES)](https://aws.amazon.com/ses/) HTML templates are the default templates used for
notifications sent from the Consent Management service. The HTML template verbiage should also be a reflection of what's
documented in [Confluence](https://adatree.atlassian.net/wiki/x/AQBAGw).

## Minifying HTML

HTML templates must be minified (using online tools) before being injected into the service. Be careful when minifying
and ensure the formatter does not remove necessary spaces. These minified templates are currently put into
[adr-platform-deploy](https://github.com/Adatree/adr-platform-deploy/blob/main/service-catalog/products/per-tenant-infra/stack-of-stacks.yaml).

## Email Subjects

| Template name              | Subject                                                                  |
|----------------------------|--------------------------------------------------------------------------|
| consent-expired.min.html   | Data sharing with {{granteeName}} has expired                            |
| consent-granted.min.html   | Consent to share your data with {{granteeName}}                          |
| consent-reminder.min.html  | Reminder of your data sharing with {{granteeName}}                       |
| consent-revoked.min.html   | {{granteeName}} is no longer receiving your data from {{dataHolderName}} |
| consent-withdrawn.min.html | {{granteeName}} is no longer receiving your data from {{dataHolderName}} |
| consent-extended.min.html  | Data sharing with {{granteeName}} has been extended                      |
| one-time-password.min.html | {{oneTimePassword}} is your {{sender}} one-time password                 |
| passwordless-link.html     | Sign in to {{sender}}                                                    |

## SES Attributes

| Name | Description | Possible Values/Examples |
|-|-|-|
| dataHolderName | Name of the data holder as provided by the ACCC Register. | CommBank |
| granteeName | Name of the entity receiving the data. Can be an ADR, CDR Rep or Trusted Advisor. | Brokers Inc. |
| dashboardLink | URL to the consent dashboard for consent management. | https://consent.adatree.au |
| givenAt | The date at which consent was given in `dd LLLL yyyy` format | 20 December 2022 |
| revokedAt | The date at which consent was revoked or withdrawn in `dd LLLL yyyy` format  | December 2022 |
| sharingEndDate | The date at which consent will expire in `dd LLLL yyyy` format | December 2022 |
| scopes | Contains a list of `scope` Strings. The list of data clusters accessable with consent whose wording is take from the `Data cluster language` definitions in the [Consumer Experience](https://consumerdatastandardsaustralia.github.io/standards/#consumer-experience) section of the Consumer Data Standards. | Name and occupation, Contact Details|
| purposes | Contains a list of `purpose` Strings. The list of purposes for which consent was sought | Home loan |
| postUsageAction | The action the ADR must take after consent ends. | "deleting", "de-identifying" |
| postUsageActioner | The entity who is responsible for carrying out the postUsageAction. Can be an ADR or CDR Rep. | Adatree |
| accessFrequency | The frequency at which the data is accessed at the data holder by the ADR. | "once", "multiple times" |
| osps |Contains a list of nested objects with Strings `providerName`, `serviceDescription`, `accreditationId`, `cdrPolicyUri`. Any supporting parties that are involved in delivering the service to the consumer. This started off as a list of Outsourced Service Providers (OSPs) but now incorporates any supporting party that is required to be displayed. `accreditationId`, `cdrPolicyUri` are only included if the Supporting Party is an ADR. | Adatree Pty Ltd, Adatree is a CDR SaaS provider, ADRBNK000071, https://adatree.com.au/cdrpolicy|

## Troubleshooting

```text
An error occurred (MessageRejected) when calling the SendTemplatedEmail operation: Email address is not verified. 
The following identities failed the check in region XXX: xxx@yyy.com
```

* Amazon SES > Configuration: Identities
* Click `Create Identity`
* Follow the prompts to add a verified email address

## Cheatsheet

```bash
#configure tenant
export tenant=xxxxxx
export testemail=xxxxxx
export dashboardDomain=xxxxxx
```

Don't forget to prepend the following commands with the appropriate `AWS_PROFILE` that you want to send the email
template from!

```bash
#trigger test email for consent reminder
aws ses send-templated-email --source ${testemail} --destination ToAddresses=${testemail} --template ${tenant}-consent-reminder --template-data '{ "dataHolderName":  "Red Australia Bank", "granteeName": "John Doe", "dashboardLink":  "https://${dashboardDomain}.dashboard.adatree.com.au/", "givenAt": "some time in future", "sharingEndDate":  "right now", "scopes": "scope 1 scope 2 scope 3", "purposes":  "test email template", "accessFrequency": "ongoing" }'
```

```bash
#trigger test email for consent expiry 
aws ses send-templated-email --source ${testemail} --destination ToAddresses=${testemail} --template ${tenant}-consent-expired --template-data '{ "dataHolderName":  "Red Australia Bank", "granteeName": "John Doe", "dashboardLink":  "https://${dashboardDomain}.dashboard.adatree.com.au/", "givenAt": "some time in future", "sharingEndDate":  "right now", "scopes": "scope 1 scope 2 scope 3", "purposes":  "test email template", "accessFrequency": "ongoing" }'
```

```bash
#trigger test email for consent extended 
aws ses send-templated-email \
--source ${testemail} \
--destination ToAddresses=${testemail} \
--template ${tenant}-consent-extended \
--template-data '{"dashboardLink":"https://${dashboardDomain}.dashboard.adatree.com.au/","accessFrequency":"multiple times","osps":[{"cdrPolicyUri":"https://adatree.com.au/cdr-policy","serviceDescription":"hello world!","accreditationId":"ADRX00000071","providerName":"Adatree Pty Ltd"},{"serviceDescription":"MogoPlus will categorise your data","providerName":"MogoPlus"}],"dataHolderName":"Red Australia Bank","sharingEndDate":"15 May 2025","purposes":[{"purpose":"Name"}],"scopes":[{"scope":"Personal information"},{"scope":"Bank account name, type and balance"}],"givenAt":"15 May 2024","granteeName":"The end recipient of the data i.e. ADR, Rep, TA"}'
```

NB: You can easily generate mock `template-data` values by setting a breakpoint in the tests inside the consent
management service eg. `EmailServiceTest`  
