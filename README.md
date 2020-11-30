# Getting Started

## Clone Repo

Clone it.

```bash
git clone https://github.com/CodeTheDream/ride-share-rails.git
cd ride-share-rails
```

## Download Ruby

This project is using ruby 2.5.3. You must have that locally before you can begin working on this project. [Install rbenv](https://github.com/rbenv/rbenv) if you haven't already.

```bash
brew install rbenv
echo 'eval "$(rbenv init -)"' >> ~/.zshrc # or ~/.bash_profile if you're still on bash
source ~/.zshrc # or close the window and relaunch
rbenv install 2.6.0 # and wait for it to finish
```

## Get credentials
Get the right credentials and master key from one of the main devs on the project. Run the following to make sure the credentials are set correctly. Otherwise, the seeder will complain about not having the correct Google Maps API key when you go to try set up the DB.

```bash
EDITOR="vim" rails credentials:edit
```

You should have entries for the following values:
```ruby
GMAIL_USERNAME:
GMAIL_PASSWORD:
GOOGLE_API_KEY:
SENDGRID_API_KEY:
```

Make sure that `config/master.key` has the correct master key.

## Build the app and run it

```bash
bundle
rails db:setup
rails s
```


# API Documentation

- [Authentication](#authentication)
- [Settings](#settings)
- [Locations](#locations)
- [Availability](#availability)
- [Rides](#rides)

### Authentication

**TODO**

### Settings

**TODO**

### Locations

<details>
<summary>GET /locations</summary>
**Description:**

Return all locations saved by the user.

**Response Example:**
```json
[
  {
    "id": 1,
    "street_address": "123 Pine St.",
    "city": "Durham",
    "state": "NC",
    "zip": "27609"
  },
  {
    "id": 2,
    "street_address": "123 Oak St.",
    "city": "Durham",
    "state": "NC",
    "zip": "27609"
  },
]
```
</details>


<details>
<summary>POST /locations</summary>

**Description:**

Save a location for future use.

**Request Body:**

```json
{
  "street_address": "123 Oak St.",
  "city": "Durham",
  "state": "NC",
  "zip": "27609"
}
```

**Response:**
```json
{
  "id": 3,
  "street_address": "123 Oak St.",
  "city": "Durham",
  "state": "NC",
  "zip": "27609"
}
```

</details>


<details>
<summary>DELETE /locations/:id</summary>

**Description:**

Deletes an address from the list of saved addresses.

**Response:**

{ success: true }
</details>


### Availability

<details>
<summary>GET /availabilities</summary>
**Description:**

Returns an array with all the scheduled available time slots within the given range.

**Params:**

- `start`: timestamp where range begins
- `end`: timestamp where range ends

**Response Example:**
```json
[
  {
    "id": 1,
    "start": "2019-02-07 18:00",
    "end": "2019-02-07 20:00",
    "recurring": true,
    "location": {
      "street_address": "123 Pine St.",
      "city": "Durham",
      "state": "NC",
      "zip": "27609"
    }
  },
  {
    "id": 2,
    "start": "2019-02-08 18:00",
    "end": "2019-02-08 20:00",
    "recurring": false,
    "location": {
      "street_address": "123 Pine St.",
      "city": "Durham",
      "state": "NC",
      "zip": "27609"
    }
  },
  {
    "id": 1,
    "start": "2019-02-14 18:00",
    "end": "2019-02-14 20:00",
    "recurring": true,
    "location": {
      "street_address": "123 Pine St.",
      "city": "Durham",
      "state": "NC",
      "zip": "27609"
    }
  },
]
```
</details>


<details>
<summary>POST /availabilities</summary>

**Description:**

Save a new availability

**Request Body:**

```json
{
  "start_date": "2019-02-14 18:00",
  "end_date": "2019-02-14 20:00",
  "start_time": "2019-02-14 18:00",
  "end_time": "2019-02-14 20:00",
  "recurring": true,
  "location_id": 1
}
```

**Response:**
```json
{
  "id": 6,
  "start": "2019-02-14 18:00",
  "end": "2019-02-14 20:00",
  "recurring": true,
  "location": {
    "street_address": "123 Pine St.",
    "city": "Durham",
    "state": "NC",
    "zip": "27609"
  }
}
```
</details>

<details>
<summary>PUT /availabilities/:id</summary>

**Description:**

Update an existing availability

**Request Body:**

```json
{
  "id": 6,
  "start": "2019-02-14 18:00",
  "end": "2019-02-14 20:00",
  "recurring": true,
  "location": {
    "street_address": "123 Pine St.",
    "city": "Durham",
    "state": "NC",
    "zip": "27609"
  }
}
```

**Response:**
```json
{
  "id": 6,
  "start": "2019-02-14 18:00",
  "end": "2019-02-14 20:00",
  "recurring": true,
  "location": {
    "street_address": "123 Pine St.",
    "city": "Durham",
    "state": "NC",
    "zip": "27609"
  }
}
```
</details>



<details>
<summary>DELETE /locations/:id</summary>

**Description:**

Removes an availability

**Response:**

{ success: true }

</details>


### Rides

<details>
<summary>GET /rides</summary>
**Description:**

Returns an array with all the rides within a given range

**Params:**

- `start`: ***optional*** timestamp where range begins
- `end`: ***optional*** timestamp where range ends
- `states`: ***optional*** list of states the rides are in

***Possible States:***

- `pending`: request has been made but has not been approved by the organization
- `approved`: request has been approved and drivers alerted about ride
- `scheduled`: request has been matched with a driver and scheduled
- `picking-up`: driver has started driving to pick up rider (discuss)
- `dropping-off`: driver has picked up rider and is driving to final destination (discuss)
- `completed`: driver has dropped of rider at final destination
- `canceled`: driver or rider has canceled the ride


**Response Example:**
`GET /api/v1/rides?start=2019-01-01&end=2019-02-01&states=approved,scheduled`
```json
[
  {
    "id": 1,
    "pickupTime": "2019-02-07 18:00",
    "riderName": "John Smith",
    "riderPhone": "919-123-4567",
    "state": "scheduled",
    "pickupLocation": {
      "street_address": "123 Pine St.",
      "city": "Durham",
      "state": "NC",
      "zip": "27609"
    },
    "dropoffLocation": {
      "street_address": "124 Pine St.",
      "city": "Durham",
      "state": "NC",
      "zip": "27609"
    }
  },
  {
    "id": 2,
    "pickupTime": "2019-02-07 18:00",
    "riderName": "Amy Smith",
    "riderPhone": "919-123-4568",
    "state": "approved",
    "pickupLocation": {
      "street_address": "124 Pine St.",
      "city": "Durham",
      "state": "NC",
      "zip": "27609"
    },
    "dropoffLocation": {
      "street_address": "123 Pine St.",
      "city": "Durham",
      "state": "NC",
      "zip": "27609"
    }
  },
]
```
</details>


<details>
<summary>POST /rides/:id/accept</summary>

**Description:**

Driver accepts the ride

**Request Body:**

```json
{
}
```

**Response:**
```json
{
  "id": 2,
  "pickupTime": "2019-02-07 18:00",
  "riderName": "Amy Smith",
  "riderPhone": "919-123-4568",
  "state": "scheduled",
  "pickupLocation": {
    "street_address": "124 Pine St.",
    "city": "Durham",
    "state": "NC",
    "zip": "27609"
  },
  "dropoffLocation": {
    "street_address": "123 Pine St.",
    "city": "Durham",
    "state": "NC",
    "zip": "27609"
  }
}
```
</details>

<details>
<summary>POST /rides/:id/complete</summary>

**Description:**

Driver complete the ride

**Request Body:**
In the future we might want to get feedback from the driver here.
```json
{
}
```

**Response:**
```json
{
  "id": 2,
  "pickupTime": "2019-02-07 18:00",
  "riderName": "Amy Smith",
  "riderPhone": "919-123-4568",
  "state": "complete",
  "pickupLocation": {
    "street_address": "124 Pine St.",
    "city": "Durham",
    "state": "NC",
    "zip": "27609"
  },
  "dropoffLocation": {
    "street_address": "123 Pine St.",
    "city": "Durham",
    "state": "NC",
    "zip": "27609"
  }
}
```
</details>

<details>
<summary>POST /rides/:id/cancel</summary>

**Description:**

Driver cancels the ride

**Request Body:**
```json
{
  "message": "my car broke down"
}
```

**Response:**
```json
{
  "id": 2,
  "pickupTime": "2019-02-07 18:00",
  "riderName": "Amy Smith",
  "riderPhone": "919-123-4568",
  "state": "cancele",
  "pickupLocation": {
    "street_address": "124 Pine St.",
    "city": "Durham",
    "state": "NC",
    "zip": "27609"
  },
  "dropoffLocation": {
    "street_address": "123 Pine St.",
    "city": "Durham",
    "state": "NC",
    "zip": "27609"
  }
}
```
</details>
