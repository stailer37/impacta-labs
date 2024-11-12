db.products.insertMany([
    {
        "description": "Yellow",
        "artist": "Pink Floyd",
        "price": 19.99,
        "quantity": 2  
    },
])

db.products.aggregate([
    {
        $match: {
            "artist": "Pink Floyd"
        }
    },
    {
        $group: {
            _id: "$artist",
            total: {
                $sum: "$price"
            }
        }
    }
])