export type SolanaElm = {
  "version": "0.1.0",
  "name": "solana_elm",
  "instructions": [
    {
      "name": "increment",
      "accounts": [
        {
          "name": "user",
          "isMut": true,
          "isSigner": false
        },
        {
          "name": "payer",
          "isMut": true,
          "isSigner": true
        },
        {
          "name": "systemProgram",
          "isMut": false,
          "isSigner": false
        }
      ],
      "args": []
    }
  ],
  "accounts": [
    {
      "name": "user",
      "type": {
        "kind": "struct",
        "fields": [
          {
            "name": "increment",
            "type": "u8"
          }
        ]
      }
    }
  ]
};

export const IDL: SolanaElm = {
  "version": "0.1.0",
  "name": "solana_elm",
  "instructions": [
    {
      "name": "increment",
      "accounts": [
        {
          "name": "user",
          "isMut": true,
          "isSigner": false
        },
        {
          "name": "payer",
          "isMut": true,
          "isSigner": true
        },
        {
          "name": "systemProgram",
          "isMut": false,
          "isSigner": false
        }
      ],
      "args": []
    }
  ],
  "accounts": [
    {
      "name": "user",
      "type": {
        "kind": "struct",
        "fields": [
          {
            "name": "increment",
            "type": "u8"
          }
        ]
      }
    }
  ]
};
