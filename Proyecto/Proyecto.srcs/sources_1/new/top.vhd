LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY top IS
    PORT (
         boton, piso_actual: IN std_logic_vector (3 downto 0);
         clk, reset: IN std_logic;
         objeto: IN std_logic;
         luz, puerta: OUT std_logic;
         motor: OUT std_logic_vector (1 downto 0);
         display: OUT std_logic_vector (6 downto 0)
         );
    END top;

ARCHITECTURE behavioral OF top IS

    COMPONENT decoder
        port(
            code : in std_logic_vector(3 downto 0);
            led : out std_logic_vector(6 downto 0)
        );
    END COMPONENT;

    TYPE estado IS (reposo, cerrar, mover);
    SIGNAL presente: estado:= reposo;
    SIGNAL boton_pulsado: std_logic_vector(3 DOWNTO 0):=boton;
    SIGNAL destino_fijado: std_logic:= '0';
    SIGNAL piso_destino: std_logic_vector(3 DOWNTO 0); 
BEGIN

    INST_DECODER: decoder PORT MAP(
        code => piso_actual,
        led => display);

    estados: PROCESS (reset, clk)
    BEGIN
        IF reset = '1' THEN
            presente <= reposo;
            
        ELSIF clk = '1' AND clk'event THEN
            CASE presente IS
            
            WHEN reposo =>
                IF boton /= "0000" AND boton /= piso_actual THEN
                    presente <= cerrar;
                    boton_pulsado <= boton;
                END IF;
                
            WHEN cerrar =>
                IF objeto = '0' THEN
                    IF destino_fijado = '0' THEN -- Funcion para que el destino no varie aún cuando se accione otro botón
                        piso_destino <= boton_pulsado;
                        destino_fijado <= '1';
                    END IF;
                    presente <= mover; --Sin obstáculo            
                END IF;
                
            WHEN mover =>
                IF piso_actual = piso_destino THEN                    
                    destino_fijado <= '0';
                    presente <= reposo; --Ya llego al piso
                END IF;
            END CASE;
        END IF;
    END PROCESS;
    
    salida: PROCESS (presente)
    BEGIN
        CASE presente IS
            WHEN mover =>
                luz <= '1'; --Luz encendida
                puerta <= '1'; --Cierra puerta
                
                IF boton_pulsado > piso_actual THEN --Ascensor sube
                    motor <= "10";
                    
                ELSE --Ascensor baja
                    motor <= "01";
                END IF;
                
            WHEN OTHERS =>
                motor <= "00";  --Ascensor Parado
                puerta <= '0';  --Puerta abierta
                luz <= '0'; --Luz apagada
        END CASE;
    END PROCESS;
END behavioral;

