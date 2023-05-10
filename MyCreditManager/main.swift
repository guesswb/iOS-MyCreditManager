//
//  main.swift
//  MyCreditManager
//
//  Created by 김기훈 on 2023/04/30.
//

import Foundation

final class CreditManager {
    private var students: [String: Student] = [:]
    private let gradeData: [String: Double] = ["A+": 4.5, "A": 4.0, "B+": 3.5, "B": 3.0, "C+": 2.5, "C": 2.0, "D+": 1.5, "D": 1.0, "F": 0]
    
    struct Student {
        var name: String
        var scores: [String: (grade: String, score: Double)] = [:]
        
        mutating func addScore(subject: String, grade: String, score: Double) {
            scores[subject] = (grade, score)
            print("\(name) 학생의 \(subject) 과목이 \(grade)로 추가(변경)되었습니다.")
        }
        
        mutating func deleteScore(subject: String) throws {
            guard scores[subject] != nil else {
                throw CreditManagerError.failFindSubject(subject: subject)
            }
            
            scores[subject] = nil
            print("\(name) 학생의 \(subject) 과목의 성적이 삭제되었습니다.")
        }
        
        func calculateAverageScore() {
            scores.forEach { print("\($0.key): \($0.value.grade)") }
            let averageScore = String(format: "%.2f", scores.values.map({ $0.score }).reduce(0, +) / Double(scores.count))
            print("평점 : \(averageScore)")
        }
    }
    
    enum RequestText {
        static let requestFeature: String = "원하는 기능을 입력해주세요\n1: 학생추가, 2: 학생삭제, 3: 성적추가(변경), 4:성적삭제, 5: 평점보기, X: 종료"
        static let addStudent: String = "추가할 학생의 이름을 입력해주세요."
        static let deleteStudent: String = "삭제할 학생의 이름을 입력해주세요."
        static let addScore: String = "성적을 추가할 학생의 이름, 과목 이름, 성적(A+, A, F 등)을 띄어쓰기로 구분하여 차례로 작성해주세요.\n입력예) Mickey Swift A+\n만약에 학생의 성적 중 해당 과목이 존재하면 기존 점수가 갱신됩니다."
        static let deleteScore: String = "성적을 삭제할 학생의 이름, 과목 이름을 띄어쓰기로 구분하여 차례로 작성해주세요.\n입력예) Mickey Swift"
        static let calculateAverageGrage: String = "평점을 알고 싶은 학생의 이름을 입력해주세요."
    }
    
    enum CreditManagerError: CustomDebugStringConvertible, Error {
        case wrongMenuInput
        case wrongDataInput
        
        case failAddStudent(name: String)
        case failDeleteStudent(name: String)
        case failFindStudent(name: String)
        case failFindSubject(subject: String)
        
        var debugDescription: String {
            switch self {
            case .wrongMenuInput: return "뭔가 입력이 잘못되었습니다. 1~5 사이의 숫자 혹은 X를 입력해주세요."
            case .wrongDataInput: return "입력이 잘못되었습니다. 다시 확인해주세요."
            case .failAddStudent(let name): return "\(name)은 이미 존재하는 학생입니다. 추가하지 않습니다."
            case .failDeleteStudent(let name): return "\(name) 학생을 찾지 못했습니다."
            case .failFindStudent(let name): return "\(name) 학생을 찾지 못했습니다."
            case .failFindSubject(let subject): return "\(subject) 과목을 찾지 못했습니다."
            }
        }
    }
}

extension CreditManager {
    func requestInput() {
        do {
            print(RequestText.requestFeature)
            
            guard let input = readLine() else {
                throw CreditManagerError.wrongMenuInput
            }
            
            switch input {
            case "1": try addStudent()
            case "2": try deleteStudent()
            case "3": try addScore()
            case "4": try deleteScore()
            case "5": try caculateAverageScore()
            case "X": quitProgram()
            default: throw CreditManagerError.wrongMenuInput
            }
        } catch {
            print(error)
        }
        
        requestInput()
    }

    private func addStudent() throws {
        print(RequestText.addStudent)
        
        guard let name = readLine(), name.isEmpty == false else {
            throw CreditManagerError.wrongDataInput
        }
        
        if students[name] != nil {
            throw CreditManagerError.failAddStudent(name: name)
        }
        
        students[name] = Student(name: name)
        print("\(name) 학생을 추가했습니다.")
    }
    
    private func deleteStudent() throws {
        print(RequestText.deleteStudent)
        
        guard let name = readLine(), name.isEmpty == false else {
            throw CreditManagerError.wrongDataInput
        }
        
        if students[name] == nil {
            throw CreditManagerError.failDeleteStudent(name: name)
        }
        
        students[name] = nil
        print("\(name) 학생을 삭제했습니다.")
    }
    
    private func addScore() throws {
        print(RequestText.addScore)
        
        guard let input = readLine()?.split(separator: " ").map({ String($0) }),
              input.count == 3,
              let score = gradeData[input[2]],
              var student = students[input[0]] else {
            throw CreditManagerError.wrongDataInput
        }
        
        student.addScore(subject: input[1], grade: input[2], score: score)
    }
    
    private func deleteScore() throws {
        print(RequestText.deleteScore)
        
        guard let input = readLine()?.split(separator: " ").map({ String($0) }),
              input.count == 2 else {
            throw CreditManagerError.wrongDataInput
        }
        
        guard var student = students[input[0]] else {
            throw CreditManagerError.failFindStudent(name: input[0])
        }
        
        try student.deleteScore(subject: input[1])
    }
    
    private func caculateAverageScore() throws {
        print(RequestText.calculateAverageGrage)
        
        guard let name = readLine(), name.isEmpty == false else { throw CreditManagerError.wrongDataInput }
        
        guard let student = students[name] else {
            throw CreditManagerError.failFindStudent(name: name)
        }
        
        student.calculateAverageScore()
    }
    
    private func quitProgram() {
        print("프로그램을 종료합니다...")
        exit(0)
    }
}

let creditManager = CreditManager()
creditManager.requestInput()
