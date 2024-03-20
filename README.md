# BAT end-to-end tests

This repo contains end-to-end tests that aim to cover the "Becoming a Teacher" service line.

## Running locally

1. Clone this repo.
2. `bundle install`
3. `rake`

## Work undertaken

The intention of this repo was to explore end-to-end testing across the following BAT services:
- [Publish](https://qa.publish-teacher-training-courses.service.gov.uk)
- [Find](https://qa.find-postgraduate-teacher-training.service.gov.uk/)
- [Apply](https://qa.apply-for-teacher-training.service.gov.uk/)
- [Manage](https://qa.apply-for-teacher-training.service.gov.uk/)

The goal was to provide testing to ensure that a course (once published), could be found by a candidate, applied for by a candidate and finally managed by a provider.

Whilst we were able to write tests to met the needs of following this journey. We encountered several issues along the way, which prevented us from continuing this project at this time.

## Encountered Issues

1. To test these services we ran our scenarios against the QA environments of each service. While the Publish QA environment allowed us to sign in using personas, Apply used 'magic links' for candidate authentication. This required us to use the GOV.UK Notify API to extract the magic links from sent emails which would allow us to sign in successfully.

2. Due to the nature of our tests, we couldn't rely on APIs for testing that a course could be found across the services. We required visual confirmation that a course would appear to a user across the services with the correct information.

3. Given that we were unable to use the IDs of specific records, it was difficult to locate if certain records were visible on a page. We had to resort to using attributes such as name, status, etc. to identify the records we were attempting to locate and test. This again became problematic, as running the tests multiple times produced duplicate records, making the scenario difficult to test.

4. Not knowing the IDs for specific records also meant that we had to loop over elements within the view, in order to identify the record we were trying to locate. We were aware that any changes to classes within the HTML would result in this tests failing, however it was necessary given the limited information we had to find the correct elements on the page.

5. The restrictions and limitations set in certain services, such as "You can only apply for a course once" and "You only submit 15 unsuccessful applications" meant that we had to make additional step to withdrawn any previous applications created by previously running our tests, and that our test suite could only be run 15 times using a single DfE account before tests began to fail.
 
## Conclusion

Date: 20/03/2024

Whilst this project has provided end-to-end testing across the application journey of BAT and its various services. Due to the limitations and restrictions we have encountered, we have decided that it is not beneficial to continue with this project.

This project could be valuable in future, but first it'd be necessary to define which environment the tests should run in. There would be little value in using these as integration tests in the QA environment because the integration between Find/Publish and Apply/Manage is already well established and stable. They would be difficult to use as smoke tests because that would require them to run against production, where we can't publish courses and submit real-world applications.