@crud
Feature: https://petstore.swagger.io api otomasyon testleri - CRUD operasyonları

  Background:
    * def baseUrl = "https://petstore.swagger.io/v2"

  Scenario: create a new pet data
    * def newPet =
    """
    {
  "name": "Pamuk",
  "photoUrls": [
    "<string>",
    "<string>"
  ],
  "id": 1001,
  "category": {
    "id": 1,
    "name": "cat"
  },
  "tags": [
    {
      "id": 1,
      "name": "<string>"
    },
    {
      "id": 1,
      "name": "<string>"
    }
  ],
  "status": "pending"
}
    """
    Given url baseUrl
    And path "pet"
    And header Accept = 'application/json'
    And header Content-Type = 'application/json'
    And request newPet
    When method post
    Then status 200
    And match response == newPet
    * match response.id == '#number'
    * match response.status == '#string'
    #json dosyasındaki veri ile karşılaştırma
    * def newPetJsonFile = read('classpath:data/petstore.json')
    * match response == newPetJsonFile

  Scenario: get new created pet data
    Given url baseUrl
    And path "pet/1001"
    And header Accept = 'application/json'
    And header Content-Type = 'application/json'
    When method get
    Then status 200
    And match header Content-Type == 'application/json'
    * match header Access-Control-Allow-Methods == 'GET, POST, DELETE, PUT'
    * match response.id == 1001
    * match response.category.name == "Pamuk"
    * match response.status == "pending"


Scenario: update pet data
    Given url baseUrl
    And path "pet"
    And request
    """
    {
  "name": "Yumak",
  "photoUrls": [
    "<string>",
    "<string>"
  ],
  "id": 1001,
  "category": {
    "id": 1,
    "name": "cat"
  },
  "tags": [
    {
      "id": 1,
      "name": "<string>"
    },
    {
      "id": 1,
      "name": "<string>"
    }
  ],
  "status": "sold"
}
    """
    And header Accept = 'application/json'
    And header Content-Type = 'application/json'
    When method put
    Then status 200
    And match header Content-Type == 'application/json'
    * match response.id == 1001
    * match response.name == "Yumak"
    * match response.category.name == "cat"
    * match response.status == "sold"

  Scenario: delete pet
    Given url baseUrl
    And path "pet/1001"
    When method delete
    Then status 200
    And match header Content-Type == 'application/json'
    And match header Access-Control-Allow-Methods == 'GET, POST, DELETE, PUT'
    And match response.type=="unknown"
    And match response.message=="1001"