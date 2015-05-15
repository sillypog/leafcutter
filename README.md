# leafcutter [![Build Status](https://travis-ci.org/sillypog/leafcutter.svg?branch=master)](https://travis-ci.org/sillypog/leafcutter)
Find leaves in tree-like json structures

The JSON data structure must satisfy these conditions:
* It must start with a single "trunk" node.
* The trunk node may contain any number of "branch" nodes.
* Branch nodes may either:
  1. Terminate in a "leaf", which must be an array.
  2. Contain another trunk node. The structure can then repeat to any depth.

For example:
```
{
  "tag": {
    "": {
      "international": {
        "false": {
          "owner": {
            "": {
              "promoted": {
                "false": ["A", "B", "C", "D", "E"],
                "true": ["G", "A", "B", "C", "D", "F"]
              }
            },
            "admin": {
              "promoted": {
                "false": ["A", "C", "B", "D", "E"],
                "true": ["G", "A", "C", "B", "D", "H", "F"]
              }
            },
            "public": {
              "promoted": {
                "false": ["B", "D", "A", "C", "E"],
                "true": ["B", "D", "I", "A", "C", "F"]
              }
            }
          }
        },
        "true": {
          "owner": {
            "": {
              "promoted": {
                "true": ["A", "B", "G", "D"],
                "false": ["A", "B", "C", "D"]
              }
            },
            "admin": {
              "promoted": {
                "true": ["A", "B", "G", "C", "D", "I"],
                "false": ["A", "B", "C", "D"]
              }
            },
            "public": {
              "promoted": {
                "true": ["B", "A", "D", "I", "C"],
                "false": ["B", "A", "D", "C"]
              }
            }
          }
        }
      }
    },
    "upcoming": {
      "international": {
        "false": {
          "owner": {
            "": ["C", "D", "A", "B", "E"],
            "admin": ["C", "D", "A", "B", "E"],
            "public": ["D", "C", "B", "A", "E"]
          }
        },
        "true": ["C", "D", "A", "B"]
      }
    }
  }
}
```

Leafcutter makes it simple to query this data structure to find the leaf that satisfies a set of conditions.

First, create a Leafcutter instance containing the data structure.

```
leafcutter = Leafcutter.new json_data_structure
```

Then run your queries.

```
admin_query = {
  'tag' => '',
  'international' => 'false',
  'owner' => 'admin',
  'promoted' => 'false'
}

leafcutter.run admin_query
  # => ["A", "C", "B", "D", "E"]

upcoming_query = {
	'tag' => 'upcoming',
	'international' => 'true',
	'owner' => 'public',
	'promoted' => 'true'
}

leafcutter.run upcoming_query
  # => ["C", "D", "A", "B"]

```

This provides flexibility to the data structure, as only a minimal subset of query conditions must be met; eg, the owner and promoted keys of the `upcoming_query` have no effect - the query terminates at the leaf node of international:'true'.
