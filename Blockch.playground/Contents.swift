// A Place where ppl can play

import Cocoa


//  Our simple model representing a transaction

protocol SmartContract {
    func apply(transaction :Transaction)
    
    }
//Create a smart contract
class TransactionTypeSmartContract : SmartContract {
    
    func apply(transaction: Transaction)   {
        
        var fees = 0.0
        
        switch transaction.transactionType {
            case .domestic:
                fees = 0.02
            case .international:
                fees = 0.05
                
        }
        
        transaction.fees = transaction.amount * fees
        transaction.amount -= transaction.fees
        
    }
}


enum TransactionType : String, Codable {
    case domestic
    case international
    
}

class Transaction : Codable { //Codable means it could be converted to JSON object
    
    var from :String
    var to :String
    var amount :Double
    var fees :Double = 0.0
    var transactionType :TransactionType
    
    init(from :String, to :String, amount :Double, transactionType :TransactionType) {
        self.from = from
        self.to = to
        self.amount = amount
        self.transactionType = transactionType
        
    }
}

// Let's create a model that's represents a Block
// A block can have multiple transactions

class Block : Codable {
    
    //Position of the block in the block chain
    var index :Int = 0 //since the first position is 0
    var previousHash :String = "" //we will initialize to empty for right now
    var hash : String!
    var nonce :Int
    
    private (set) var transactions :[Transaction] = [Transaction]() //Transaction is an array or a list
    
    var key :String {
        get {
            
            let transactionsData = try! JSONEncoder().encode(self.transactions) //It's going to give us a transactions data
            let transactionsJSONString = String(data: transactionsData, encoding: .utf8)
            
            return String(self.index) + self.previousHash + String(self.nonce) + transactionsJSONString!// transaction in a JSON format
        }
    }
    
    func addTransaction(transaction :Transaction) {
        self.transactions.append(transaction)
    }
    
    //Let's add the transactions to the Block
    
    
    
    init() {
        self.nonce = 0
        
    }
    
}


//Let's implement the class for an actual Block Chain

class Blockchain : Codable {
    //Blockchain class has a list of Blocks
    
    private (set) var blocks :[Block] = [Block]() //List of blocks is an empty array, it doesn't really have any blocks
    private (set) var smartContracts :[SmartContract] =
        [TransactionTypeSmartContract()]
    
    
    init(genesisBlock :Block) {
        addBlock(genesisBlock)
        
    }
    
    private enum CodingKeys : CodingKey {
        case blocks
        
    }
    
    func addBlock(_ block :Block) {
        
        if self.blocks.isEmpty {
            block.previousHash = "0000000000000000"
            block.hash = generateHash(for :block)
        }
        
        self.blocks.append(block)
        
        
    }
    
    func getNextBlock(transactions :[Transaction]) -> Block {
        
        let block = Block()
        transactions.forEach { transaction in
            block.addTransaction(transaction: transaction)
            
        }
        
        let previousBlock = getPreviousBlock()
        block.index = self.blocks.count
        block.previousHash = previousBlock.hash
        block.hash = generateHash(for: block)
        return block
    }
    
    private func getPreviousBlock() -> Block {
        return self.blocks[self.blocks.count - 1]
      
    }
    
    func generateHash(for block :Block) -> String {
        
        
        var hash = block.key.sha1Hash()
        //Let's generate a special kind of hash starting with 2 0's for instance
        
        while(!hash.hasPrefix("00")) {
            block.nonce += 1 //if there's no 2 0's we are simply going to increase by 1
            hash = block.key.sha1Hash()
            print(hash)
            
        }
        
        return hash
    }
    
}


// String Extension
extension String {
    
    func sha1Hash() -> String {
        
        
        let task = Process()
        task.launchPath = "/usr/bin/shasum"
        task.arguments = []
        
        let inputPipe = Pipe()
        
        inputPipe.fileHandleForWriting.write(self.data(using: String.Encoding.utf8)!)
        
        inputPipe.fileHandleForWriting.closeFile()
        
        let outputPipe =  Pipe()
        task.standardOutput = outputPipe
        task.standardInput = inputPipe
        task.launch()
        
        let data = outputPipe.fileHandleForReading.readDataToEndOfFile()
        let hash = String(data: data, encoding: String.Encoding.utf8)!
        return hash.replacingOccurrences(of: " -\n", with: "")
        
    }
    
}

let genesisBlock = Block()
let blockchain = Blockchain(genesisBlock: genesisBlock)
//Let's create a transaction now

let transaction = Transaction(from: "Mary", to: "John", amount: 10, transactionType :.international)
print("-------------------------------------------------")

let block = blockchain.getNextBlock(transactions: [transaction])

//Our goal is to find a magical hash and in order to find it we would have to write a proof of work algorithm
blockchain.addBlock(block)

let data = try! JSONEncoder().encode(blockchain)
let blockchainJSON = String(data : data, encoding: .utf8)

print(blockchainJSON!)


