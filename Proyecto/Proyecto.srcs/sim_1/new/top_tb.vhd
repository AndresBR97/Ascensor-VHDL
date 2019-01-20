LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY top_tb is
END top_tb;

ARCHITECTURE Behavioral of top_tb is
    COMPONENT top is
        PORT(
            boton, piso_actual: IN std_logic_vector (3 downto 0);
            clk, reset: IN std_logic;
            objeto: IN std_logic;
            luz, puerta: OUT std_logic;
            motor: OUT std_logic_vector (1 downto 0);
            display: OUT std_logic_vector (6 downto 0));
    END COMPONENT;  
    
    SIGNAL boton, piso_actual : std_logic_vector (3 DOWNTO 0);
    SIGNAL clk, reset, objeto: std_logic;
    SIGNAL luz, puerta: std_logic;
    SIGNAL motor: std_logic_vector(1 DOWNTO 0);
    SIGNAL display: std_logic_vector(6 DOWNTO 0);
    CONSTANT clk_period: time := 10 ns;
         
BEGIN

    utt: top PORT MAP(
        boton => boton,
        piso_actual => piso_actual,
        clk => clk,
        reset => reset,
        objeto => objeto,
        luz => luz,
        puerta => puerta,
        motor => motor,
        display => display);
        
    clk_process: PROCESS
    BEGIN
        clk <= '0';
        WAIT FOR clk_period/2; 
        clk <= '1';
        WAIT FOR clk_period/2;
    END PROCESS;  
   
    simul_process: PROCESS
    BEGIN
        reset <= '1';
        piso_actual <= "0001";
        boton <= "0000";
        objeto <= '1';
        WAIT FOR 5 ns;
        
        reset <= '0';
        boton <= "1000";
        WAIT FOR 15 ns;
        
        objeto <= '0';
        WAIT FOR 15 ns;
        
        piso_actual <= "0010";
        WAIT FOR 15 ns;
        
        piso_actual <= "0100";
        boton <= "0010";
        WAIT FOR 15 ns;
        
        piso_actual <= "1000";
        WAIT FOR 15 ns;
        
        piso_actual <= "0100";
        WAIT FOR 15 ns;
        
        piso_actual <= "0010";
        WAIT;
                 
    END PROCESS;           
END Behavioral;
