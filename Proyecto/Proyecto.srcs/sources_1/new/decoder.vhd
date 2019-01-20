LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY decoder IS
    PORT(
        code: IN std_logic_vector(3 DOWNTO 0);
        led: OUT std_logic_vector(6 DOWNTO 0));
END ENTITY;

ARCHITECTURE dataflow OF decoder IS
BEGIN
    WITH code SELECT
        led <= "0000001" WHEN "0000",
            "1001111" WHEN "0001",
            "0010010" WHEN "0010",
            "0000110" WHEN "0100",
            "1001100" WHEN "1000",
            "0000001" WHEN OTHERS;
END dataflow;
