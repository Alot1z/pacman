import SpriteKit

class GameScene: SKScene {
    
    private var pacMan: SKSpriteNode!
    private var ghosts: [SKSpriteNode] = []
    private var dots: [SKSpriteNode] = []
    private var scoreLabel: SKLabelNode!
    private var score = 0
    private var lastUpdateTime: TimeInterval = 0
    private var direction: CGVector = .zero
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        
        pacMan = SKSpriteNode(color: .yellow, size: CGSize(width: 30, height: 30))
        pacMan.position = CGPoint(x: frame.midX, y: frame.midY)
        pacMan.name = "pacman"
        addChild(pacMan)
        
        let ghostColors: [UIColor] = [.red, .pink, .cyan, .orange]
        for i in 0..<4 {
            let ghost = SKSpriteNode(color: ghostColors[i], size: CGSize(width: 30, height: 30))
            ghost.position = CGPoint(x: frame.midX + CGFloat(i * 50 - 75), y: frame.maxY - 100)
            ghost.name = "ghost"
            ghosts.append(ghost)
            addChild(ghost)
        }
        
        for x in stride(from: 50, to: Int(frame.width) - 50, by: 50) {
            for y in stride(from: 50, to: Int(frame.height) - 50, by: 50) {
                let dot = SKSpriteNode(color: .white, size: CGSize(width: 10, height: 10))
                dot.position = CGPoint(x: x, y: y)
                dot.name = "dot"
                dots.append(dot)
                addChild(dot)
            }
        }
        
        scoreLabel = SKLabelNode(fontNamed: "Arial")
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 20
        scoreLabel.fontColor = .white
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.maxY - 40)
        addChild(scoreLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        let dx = touchLocation.x - pacMan.position.x
        let dy = touchLocation.y - pacMan.position.y
        direction = CGVector(dx: dx > 0 ? 200 : -200, dy: dy > 0 ? 200 : -200)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        direction = .zero
    }
    
    override func update(_ currentTime: TimeInterval) {
        let deltaTime = lastUpdateTime > 0 ? currentTime - lastUpdateTime : 0
        lastUpdateTime = currentTime
        
        let newPosition = CGPoint(
            x: pacMan.position.x + direction.dx * CGFloat(deltaTime),
            y: pacMan.position.y + direction.dy * CGFloat(deltaTime)
        )
        pacMan.position = CGPoint(
            x: max(15, min(frame.maxX - 15, newPosition.x)),
            y: max(15, min(frame.maxY - 15, newPosition.y))
        )
        
        for ghost in ghosts {
            let randomMove = CGVector(dx: CGFloat.random(in: -100...100), dy: CGFloat.random(in: -100...100))
            let newGhostPosition = CGPoint(
                x: ghost.position.x + randomMove.dx * CGFloat(deltaTime),
                y: ghost.position.y + randomMove.dy * CGFloat(deltaTime)
            )
            ghost.position = CGPoint(
                x: max(15, min(frame.maxX - 15, newGhostPosition.x)),
                y: max(15, min(frame.maxY - 15, newGhostPosition.y))
            )
        }
        
        for (index, dot) in dots.enumerated().reversed() {
            if pacMan.frame.intersects(dot.frame) {
                dot.removeFromParent()
                dots.remove(at: index)
                score += 10
                scoreLabel.text = "Score: \(score)"
            }
        }
        
        for ghost in ghosts {
            if pacMan.frame.intersects(ghost.frame) {
                pacMan.position = CGPoint(x: frame.midX, y: frame.midY)
                score = max(0, score - 50)
                scoreLabel.text = "Score: \(score)"
            }
        }
    }
}