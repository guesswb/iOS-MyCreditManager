//
//  main.swift
//  MyCreditManager
//
//  Created by 김기훈 on 2023/04/30.
//

import Foundation

struct Student {
    var name: String
    var scores: [String: (String, Double)] = [:]
}

final class CreditManager {
    private var students: [String: Student] = [:]
    private let gradeData: [String: Double] = ["A+": 4.5, "A": 4.0, "B+": 3.5, "B": 3.0, "C+": 2.5, "C": 2.0, "D+": 1.5, "D": 1.0, "F": 0]
}

extension CreditManager {
    func start() {
        while true {
            print("원하는 기능을 입력해주세요\n1: 학생추가, 2: 학생삭제, 3: 성적추가(변경), 4:성적삭제, 5: 평점보기, X: 종료")
            
            guard let input = readLine() else {
                printWrongMenuInput()
                continue
            }
            
            switch input {
            case "1": addStudent()
            case "2": deleteStudent()
            case "3": addScore()
            case "4": deleteScore()
            case "5": caculateGrade()
            case "X": quitProgram()
            default: printWrongMenuInput()
            }
        }
    }
    
    private func printWrongMenuInput() {
        print("뭔가 입력이 잘못되었습니다. 1~5 사이의 숫자 혹은 X를 입력해주세요.")
    }
    
    private func printWrongDataInput() {
        print("입력이 잘못되었습니다. 다시 확인해주세요.")
    }
    
    private func addStudent() {
        print("추가할 학생의 이름을 입력해주세요.")
        
        guard let input = readLine() else { return }
        
        if input.isEmpty {
            printWrongDataInput()
            return
        }
        
        if students[input] == nil {
            students[input] = Student(name: input)
            print("\(input) 학생을 추가했습니다.")
        } else {
            print("\(input)은 이미 존재하는 학생입니다. 추가하지 않습니다.")
        }
    }
    
    private func deleteStudent() {
        print("삭제할 학생의 이름을 입력해주세요.")
        
        guard let input = readLine() else { return }
        
        if input.isEmpty {
            printWrongDataInput()
            return
        }
        
        if students[input] == nil {
            print("\(input) 학생을 찾지 못했습니다.")
        } else {
            students[input] = nil
            print("\(input) 학생을 삭제했습니다.")
        }
    }
    
    private func addScore() {
        print("성적을 추가할 학생의 이름, 과목 이름, 성적(A+, A, F 등)을 띄어쓰기로 구분하여 차례로 작성해주세요.\n입력예) Mickey Swift A+\n만약에 학생의 성적 중 해당 과목이 존재하면 기존 점수가 갱신됩니다.")
        
        guard let input = readLine() else { return }
        
        let splitedInput = input.split(separator: " ").map { String($0) }
        
        if splitedInput.count != 3 || students[splitedInput[0]] == nil {
            printWrongDataInput()
            return
        }
        
        let (name, subject, grade) = (splitedInput[0], splitedInput[1], splitedInput[2])
        
        guard let score = gradeData[grade] else {
            printWrongDataInput()
            return
        }
        
        students[name]?.scores[subject] = (grade, score)
        print("\(name) 학생의 \(subject) 과목이 \(grade)로 추가(변경)되었습니다.")
    }
    
    private func deleteScore() {
        print("성적을 삭제할 학생의 이름, 과목 이름을 띄어쓰기로 구분하여 차례로 작성해주세요.\n입력예) Mickey Swift")
        
        guard let input = readLine() else { return }
        
        let splitedInput = input.split(separator: " ").map { String($0) }
        
        if splitedInput.count != 2 {
            printWrongDataInput()
            return
        }
        
        let (name, subject) = (splitedInput[0], splitedInput[1])
        
        if students[name] == nil {
            print("\(name) 학생을 찾지 못했습니다.")
            return
        }
        
        if students[name]?.scores[subject] == nil {
            print("\(subject) 과목을 찾지 못했습니다.")
            return
        }
        
        students[name]?.scores[subject] = nil
        print("\(name) 학생의 \(subject) 과목의 성적이 삭제되었습니다.")
    }
    
    private func caculateGrade() {
        print("평점을 알고 싶은 학생의 이름을 입력해주세요.")
        
        guard let input = readLine() else { return }
        
        if input.isEmpty {
            printWrongDataInput()
            return
        }
        
        if let student = students[input] {
            var average: Double = 0
            
            for (subject, score) in student.scores {
                average += score.1
                print("\(subject): \(score.0)")
            }
            
            print("평점 : \(String(format: "%.2f", average / Double(student.scores.count)))")
        } else {
            print("\(input) 학생을 찾지 못했습니다.")
            return
        }
    }
    
    private func quitProgram() {
        print("프로그램을 종료합니다...")
        exit(0)
    }
}

let creditManager = CreditManager()
creditManager.start()
