const testRecipe = [
    {
        uuid: "d6573e1f-9ed9-41a8-9944-c4ae0bfba288",
        user_uuid: "e36814a2-e994-4a4b-ba24-cdff466628c4",
        card_uuid: "61621a51-3ae1-4b87-b7de-42261cf174ec",
        title: "Beef pie",
        index: 0,
        ingredient: "beef",
        quantity: 500,
        unit: "g",
        section: "meat",
        last_modified: "2022-12-26T22:01:00+00:00",
        kcal: 1500.0
    },
    {
        uuid: "48fa9d66-fa3c-47a4-8ec3-0486b88e7886",
        user_uuid: "e36814a2-e994-4a4b-ba24-cdff466628c4",
        card_uuid: "61621a51-3ae1-4b87-b7de-42261cf174ec",
        title: "Beef pie",
        index: 1,
        ingredient: "cooking oil",
        quantity: 3,
        unit: "tbsp",
        section: "seasonings",
        last_modified: "2022-12-26T22:01:00+00:00",
        kcal: 372.9
    },
    {
        uuid: "4015b78c-ab76-4785-b434-12c4e0324024",
        user_uuid: "e36814a2-e994-4a4b-ba24-cdff466628c4",
        card_uuid: "61621a51-3ae1-4b87-b7de-42261cf174ec",
        title: "Beef pie",
        index: 2,
        ingredient: "salt",
        quantity: null,
        unit: "to taste",
        section: "seasonings",
        last_modified: "2022-12-26T22:01:00+00:00",
        kcal: 0.0
    },
    {
        uuid: "d8883aa1-b07c-4cae-bf2d-d1c43b6dae13",
        user_uuid: "e36814a2-e994-4a4b-ba24-cdff466628c4",
        card_uuid: "61621a51-3ae1-4b87-b7de-42261cf174ec",
        title: "Beef pie",
        index: 3,
        ingredient: "pepper",
        quantity: null,
        unit: "to taste",
        section: "seasonings",
        last_modified: "2022-12-26T22:01:00+00:00",
        kcal: 0.0
    },
    {
        uuid: "5a24e0f6-4414-4387-a6f4-c7928a1ad48a",
        user_uuid: "e36814a2-e994-4a4b-ba24-cdff466628c4",
        card_uuid: "61621a51-3ae1-4b87-b7de-42261cf174ec",
        title: "Beef pie",
        index: 4,
        ingredient: "condensed beef broth",
        quantity: 2,
        unit: "tsp",
        section: "seasonings",
        last_modified: "2022-12-26T22:01:00+00:00",
        kcal: 0.4
    },
    {
        uuid: "5b0476f3-05e0-45ff-8a65-97876f73a6cd",
        user_uuid: "e36814a2-e994-4a4b-ba24-cdff466628c4",
        card_uuid: "61621a51-3ae1-4b87-b7de-42261cf174ec",
        title: "Beef pie",
        index: 5,
        ingredient: "bitter beer",
        quantity: 150,
        unit: "ml",
        section: "other",
        last_modified: "2022-12-26T22:01:00+00:00",
        kcal: 0.0
    },
    {
        uuid: "1453db08-789b-4d48-bff7-94a9bf4a1333",
        user_uuid: "e36814a2-e994-4a4b-ba24-cdff466628c4",
        card_uuid: "61621a51-3ae1-4b87-b7de-42261cf174ec",
        title: "Beef pie",
        index: 6,
        ingredient: "carrots",
        quantity: 1,
        unit: null,
        section: "veggies",
        last_modified: "2022-12-26T22:01:00+00:00",
        kcal: 0.4
    },
    {
        uuid: "023268d3-0c18-4926-86f3-a8a32b385bb2",
        user_uuid: "e36814a2-e994-4a4b-ba24-cdff466628c4",
        card_uuid: "61621a51-3ae1-4b87-b7de-42261cf174ec",
        title: "Beef pie",
        index: 7,
        ingredient: "onion",
        quantity: 1,
        unit: null,
        section: "veggies",
        last_modified: "2022-12-26T22:01:00+00:00",
        kcal: 44.0
    },
    {
        uuid: "cdaf0db4-fa44-45cb-b6c7-de04ef384fa9",
        user_uuid: "e36814a2-e994-4a4b-ba24-cdff466628c4",
        card_uuid: "61621a51-3ae1-4b87-b7de-42261cf174ec",
        title: "Beef pie",
        index: 8,
        ingredient: "sugar",
        quantity: 1,
        unit: "tsp",
        section: "seasonings",
        last_modified: "2022-12-26T22:01:00+00:00",
        kcal: 16.7
    },
    {
        uuid: "5cf391d7-f31f-4316-a3eb-d6ac999b416c",
        user_uuid: "e36814a2-e994-4a4b-ba24-cdff466628c4",
        card_uuid: "61621a51-3ae1-4b87-b7de-42261cf174ec",
        title: "Beef pie",
        index: 9,
        ingredient: "tomato paste",
        quantity: 2,
        unit: "tbsp",
        section: "seasonings",
        last_modified: "2022-12-26T22:01:00+00:00",
        kcal: 30.6
    },
    {
        uuid: "e2cf04b3-ebd0-4a9b-b515-3ba9ac568eb4",
        user_uuid: "e36814a2-e994-4a4b-ba24-cdff466628c4",
        card_uuid: "61621a51-3ae1-4b87-b7de-42261cf174ec",
        title: "Beef pie",
        index: 10,
        ingredient: "mushroom",
        quantity: 300,
        unit: "g",
        section: "veggies",
        last_modified: "2022-12-26T22:01:00+00:00",
        kcal: 39.0
    },
    {
        uuid: "45aff0c7-1557-47ac-b0a9-c6a86d13e834",
        user_uuid: "e36814a2-e994-4a4b-ba24-cdff466628c4",
        card_uuid: "61621a51-3ae1-4b87-b7de-42261cf174ec",
        title: "Beef pie",
        index: 11,
        ingredient: "flour",
        quantity: 3,
        unit: "tbsp",
        section: "seasonings",
        last_modified: "2022-12-26T22:01:00+00:00",
        kcal: 95.4
    },
    {
        uuid: "7448e16c-af20-4c98-9cae-f100f2e4a136",
        user_uuid: "e36814a2-e994-4a4b-ba24-cdff466628c4",
        card_uuid: "61621a51-3ae1-4b87-b7de-42261cf174ec",
        title: "Beef pie",
        index: 12,
        ingredient: "butter",
        quantity: 4,
        unit: "tbsp",
        section: "dairies",
        last_modified: "2022-12-26T22:01:00+00:00",
        kcal: 407.5
    },
    {
        uuid: "e15bba44-c825-4555-b9ed-d60086eb78c4",
        user_uuid: "e36814a2-e994-4a4b-ba24-cdff466628c4",
        card_uuid: "61621a51-3ae1-4b87-b7de-42261cf174ec",
        title: "Beef pie",
        index: 13,
        ingredient: "pie pastry",
        quantity: 500,
        unit: "g",
        section: "grains",
        last_modified: "2022-12-26T22:01:00+00:00",
        kcal: 2000.0
    }
]

module.exports = testRecipe