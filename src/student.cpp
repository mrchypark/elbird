//  Student.cpp

#include "student.h"

// Constructor
Student::Student(std::string name, int age, bool male) {
  this->name = name;
  this->age = age;
  this->male = male;
  this->favoriteNumbers = {2, 3, 5, 7, 11};
}

// Getters
bool Student::IsMale() { return male; }
int Student::GetAge() { return age; }
std::string Student::GetName() { return name; }
std::vector<int> Student::GetFavoriteNumbers() { return favoriteNumbers; }

// Methods
bool Student::LikesBlue() {
  return (male || age >= 10);
}
