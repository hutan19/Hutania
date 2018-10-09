// Name: Hutan Vahdat


import java.util.Scanner;

public class MultiDimensional_Array
{
	
   public static void main(String[] args)
   {
	  Scanner input = new Scanner(System.in);
	  
	  int dice1;  	// number on first die   
      int dice2; 	// number on second die
      int roll;		// user input for dice total
      int[][] rollTotal = new int[7][7]; // possible rolls
	  int combos = 0;
	  
	  // title and user prompt
	  System.out.printf("%n*************************%n*** Dice Combinations ***%n*************************%n");
	  System.out.printf("%nEnter dice total (2-12): ");         
      roll = input.nextInt();

      // initialize rollTotal to 36 values
      for (int x = 1; x <= 6; x++)
	  {
		  for(int y = 1; y <= 6; y++)
		  {
			  rollTotal[x][y] = x + y;
		  }
	  }
	  
	  // check how many combos for user input
      for (int x = 1; x <= 6; x++)
	  {
		  for(int y = 1; y <= 6; y++)
		  {
			  combos = combos + checkRoll(x, y, rollTotal, roll);
		  }
	  }
	  
	  System.out.printf("%nThere are %d combinations to make a sum of %d with dice.%nThey are:%n", combos, roll);
	  
	  // output the various combintations
      for (int x = 1; x <= 6; x++)
	  {
		  for (int y = 1; y <= 6; y++)
		  {
			  if (checkRoll(x, y, rollTotal, roll) == 1)
			  {
				  System.out.printf("\t\t%d\t%d%n", x, y);
			  }
		  }
	  }

   System.out.printf("%n");

   } 
   
   // method returns 1 for a combination of a roll and 0 for otherwise
   public static int checkRoll(int i, int j, int[][] total, int rollResult)
   {      
	  if (total[i][j] == rollResult)
	  {
		   return 1;	   	
	  }

	  else
		  return 0;
	  
   }
} // end class Dice
