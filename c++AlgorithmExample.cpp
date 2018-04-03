/*  
** Author: Debra Wilkie
** Class: CS325 Algorithms
** Date:  October 22, 2017 
** Project: Last-to-Start Algorithm
** Using the greedy algorithm to provide an optimal solution for scheduling activities from an input file
*/

#include<bits/stdc++.h>
#include <vector>
using namespace std;;

// Creating a struct for the Activities so that the set of 3 numbers
//which make up the struct (activity #, start time and finish time)
//can be maintained even while sorting by one element in the struct
struct Activity
{
    int activNum;
    int startTime;
    int finishTime;
};

// A utility function that is used for sorting
// activities struct according to start time
bool activityCompare(Activity s1, Activity s2)
{
    return (s1.startTime > s2.startTime);
}

// Returns count of maximum set of activities and the activity numbers
//using a temp vector that is cleared after use
void lastToStart(Activity arr[], int n, int x)
{
    // Sort all the activties in the struct according to start time
    sort(arr, arr+n, activityCompare);
	vector<int> tempSelection;

    // The first activity always gets selected
    int i = 0;
	cout << "Set " << x << endl;
    //cout << arr[i].activNum << " ";
	tempSelection.push_back(arr[i].activNum);
	int totalCount =0;

	// Greedy activity selector choosing the best answer
    for (int j = 1; j < n; j++)
    {
      // If this activity has finish time less than or
      // equal to the start time of previously selected
      // activity, then select it
      if (arr[j].finishTime <= arr[i].startTime)
      {
          //cout << arr[j].activNum << " ";
		  tempSelection.push_back(arr[j].activNum);
		  totalCount++;
          i = j;
      }
    }
	//cout << endl;
	//Printing the selected activites
	cout << "Number of activities selected = " << totalCount+1 << endl;
	cout << "Activities: "; 
	for (int p=totalCount; p>=0; p--)
	{
		cout << tempSelection[p] << " ";
	}
	cout << endl;
	//Clearing the temporary vector
	tempSelection.clear();
}


int main()
{
    string line, line2;
	vector<int> numArray;
	int num;
	int activNum, st, ft;
	struct Activity selection[50];
	ifstream inputFile ("act.txt");

	if (!inputFile.is_open())
       perror("error while opening file");

    if (inputFile.bad())
        perror("error while reading file");

  while(!inputFile.eof())
  {
     getline(inputFile, line);
     stringstream ss(line);
     while(ss >> num)
     {
        numArray.push_back(num);
     }
  }

    int m = numArray.size();
	int i=0;
	int x=0;
	vector<int> numAct;

	//for loop to determine number of activities in the file
	//cout << "numAct: ";
	for (i; i<m; i++)
	{
		numAct.push_back(numArray[x]);
		x=(numArray[x] *3)+1;
		m=m-x;
		//cout << numAct[i] << " ";
	}
	//cout << endl;

	//The total number of sets to complete
	int setTotal = numAct.size();
	//cout << "setTotal: " << setTotal << endl;

	//Double loop used to create the activity struct, sort and
	//find the max activities possible with the greedy algorithm.
	//The loop repeats for each unique problem set as created by the
	//input file organization (total # activites, followed by sets of 3 numbers
    //activity number, start time, finish time; repeated.
	int y=0;
	int j=1;
	for (y; y<setTotal; y++)
    {
        i=0;
        x=numAct[y];
        for (i; i<x; i++)
        {
            selection[i].activNum = numArray[j];
            selection[i].startTime = numArray[j+1];
            selection[i].finishTime = numArray[j+2];
            j=j+3;
            //cout << selection[i].activNum << " " << selection[i].startTime << " " << selection[i].finishTime << endl;
        }
        lastToStart(selection, x, y+1);
		//the j has to change to next part of array starting from
        //after the (previous # of activities)*3+2
        j=((numAct[y]*3)+2);
        cout << endl;
    }

    inputFile.close();

  return 0;
}
