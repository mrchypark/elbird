//  Student.h

#ifndef Student_H
#define Student_H

#include <string>
#include <vector>

class Student
{
public:

  // Constructor
  Student(std::string name, int age, bool male);

  // Getters
  std::string GetName();
  int GetAge();
  bool IsMale();
  std::vector<int> GetFavoriteNumbers();

  // Methods
  bool LikesBlue();

private:

  // Member variables
  std::string name;
  int age;
  bool male;
  std::vector<int> favoriteNumbers;
};

#endif /* Student_H */
