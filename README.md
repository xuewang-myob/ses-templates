# ses-templates

These [AWS Simple Email Service (SES)](https://aws.amazon.com/ses/) HTML templates are the default templates used for notifications sent from the Consent Management service. HTML templates must be minified before being injected into the service. Be care when minifying and ensure the formatter does not remove necessary spaces.

## Email Subjects

| Template name | Subject |
|-|-|
| consent-expired-min.html | Data sharing with {{dataRecipientName}} has expired |
| consent-granted-min.html | Consent to share your data with {{dataRecipientName}} |
| consent-reminder-min.html | Reminder of your data sharing with {{dataRecipientName}} |
| consent-revoked-min.html | {{dataRecipientName}} is no longer receiving your data from {{dataHolderName}} |
| consent-withdrawn-min.html | {{dataRecipientName}} is no longer receiving your data from {{dataHolderName}} |
| one-time-password.html | "{{oneTimePassword}} is your {{dataRecipientName}} one-time password" |

## SES Attributes

| Name | Description | Possible Values/Examples |
|-|-|-|
| dataHolderName | Name of the data holder as provided by the ACCC Register. | CommBank |
| dataRecipientName | Name of the entity receiving the data. Can be an ADR, Rep or Trusted Advisor. | Adatree |
| dashboardLink | URL to the consent dashboard for consent management. | https://consent.adatree.au |
| givenAt | The date at which consent was given in `dd LLLL yyyy` format | 20 December 2022 |
| revokedAt | The date at which consent was revoked or withdrawn in `dd LLLL yyyy` format  | December 2022 |
| sharingEndDate | The date at which consent will expire in `dd LLLL yyyy` format | December 2022 |
| scopes | Contains a list of `scope` Strings. The list of data clusters accessable with consent whose wording is take from the `Data cluster language` definitions in the [Consumer Experience](https://consumerdatastandardsaustralia.github.io/standards/#consumer-experience) section of the Consumer Data Standards. | Name and occupation, Contact Details|
| purposes | Contains a list of `purpose` Strings. The list of purposes for which consent was sought | Home loan |
| postUsageAction | The action the ADR must take after consent ends. | "deleting", "de-identifying" |
| accessFrequency | The frequency at which the data is accessed at the data holder by the ADR. | "once", "multiple times" |
| osps |Contains a list of nested objects with Strings `providerName`, `serviceDescription`, `accreditationId`, `cdrPolicyUri`. Any supporting parties that are involved in delivering the service to the consumer. This started off as a list of Outsourced Service Providers (OSPs) but now incorporates any supporting party that is required to be displayed. `accreditationId`, `cdrPolicyUri` are only included if the Supporting Party is an ADR. | Adatree Pty Ltd, Adatree is a CDR SaaS provider, ADRBNK000071, https://adatree.com.au/cdrpolicy|