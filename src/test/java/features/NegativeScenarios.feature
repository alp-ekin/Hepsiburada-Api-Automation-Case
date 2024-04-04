Feature: negatif senaryolar

  Background:
    * def baseUrl = "https://petstore.swagger.io/v2"

  Scenario: create a new pet data - negative scenario
    * def newPet =
    """
    {
  "name": "<string>",
  "photoUrls": [
    "<string>",
    "<string>"
  ],
  "id": "<long>",
  "category": {
    "id": "<long>",
    "name": "<string>"
  },
  "tags": [
    {
      "id": "<long>",
      "name": "<string>"
    },
    {
      "id": "<long>",
      "name": "<string>"
    }
  ],
  "status": "pending"
}
    """
    Given url baseUrl
    And path "pet"
    And request newPet
    When method post
    Then status 500
    And match response.message == "something bad happened"

  Scenario: get pet data - negative scenario
    Given url baseUrl
    And path "pet/1010"
    And header Accept = 'application/json'
    And header Content-Type = 'application/json'
    When method get
    Then status 404
    And match header Content-Type == 'application/json'
    * match header Access-Control-Allow-Methods == 'GET, POST, DELETE, PUT'
    * match response.code == 1
    * match response.message == "Pet not found"


  Scenario: get pet data - negative scenario
    Given url baseUrl
    And path "pet"
    And header Accept = 'application/json'
    And header Content-Type = 'application/json'
    When method get
    Then status 405
    And match header Content-Type == 'application/json'
    * match header Access-Control-Allow-Methods == 'GET, POST, DELETE, PUT'
    * match response.code == 405
    * match response.type == "Unknown"


  Scenario: delete pet negative scenario
    Given url baseUrl
    And path "pet/3"
    When method delete
    Then status 404
    And match response.type=="unknown"
    And match response.message=="1001"


  Scenario: get with findByStatus endpoint + field tests + contain tests
    Given url baseUrl
    And path "pet/findByStatus"
    And param status = "sold"
    When method get
    Then status 200
    And match response[0].id == 1111
    And match response[0].name == "Duman"
    And match response[0].category.name == 'dog'
    And match each response[*].category.id == '#number'
    And match each response[*].name == '#string'
    And match each response[*].status == '#present'
    And match response !contains {status:  "available"}
    * match response contains any [{"id":1111,"category":{"id":1,"name":"dog"},"name":"Duman","photoUrls":["<string>","<string>"],"tags":[{"id":1,"name":"<string>"},{"id":1,"name":"<string>"}],"status":"sold"}]
